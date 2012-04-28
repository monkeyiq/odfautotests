package org.opendocumentformat.tester;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.JAXBElement;

import org.example.documenttests.ArgumentType;
import org.example.documenttests.CommandType;
import org.example.documenttests.DocumenttestsType;
import org.example.documenttests.DocumenttestsconfigType;
import org.example.documenttests.DocumenttestsreportType;
import org.example.documenttests.EnvType;
import org.example.documenttests.InputReportType;
import org.example.documenttests.TargetType;
import org.example.documenttests.TestType;
import org.example.documenttests.TestreportType;
import org.opendocumentformat.tester.InputCreator.ODFType;
import org.opendocumentformat.tester.InputCreator.ODFVersion;
import org.opendocumentformat.tester.validator.OutputChecker;

public class Tester {

	private final List<DocumenttestsType> tests;
	private final List<DocumenttestsconfigType> configs;

	private final OutputChecker outputchecker = new OutputChecker();

	public Tester() {
		tests = new ArrayList<DocumenttestsType>();
		configs = new ArrayList<DocumenttestsconfigType>();
	}

	public void addTests(DocumenttestsType tests) {
		this.tests.add(tests);
	}

	public void addConfig(DocumenttestsconfigType config) {
		this.configs.add(config);
	}

	public DocumenttestsreportType runAllTests() {
		DocumenttestsreportType report = new DocumenttestsreportType();
		for (DocumenttestsconfigType config : configs) {
			for (TargetType target : config.getTarget()) {
				report.getTestreport().addAll(runAllTests(target));
			}
		}
		return report;
	}

	public List<TestreportType> runAllTests(TargetType target) {
		List<TestreportType> testreports = new ArrayList<TestreportType>();
		for (DocumenttestsType t : tests) {
			ODFType type = null;
			switch (t.getInputmimetype()) {
			case APPLICATION_VND_OASIS_OPENDOCUMENT_TEXT:
				type = InputCreator.ODFType.text;
				break;
			case APPLICATION_VND_OASIS_OPENDOCUMENT_PRESENTATION:
				type = InputCreator.ODFType.presentation;
				break;
			case APPLICATION_VND_OASIS_OPENDOCUMENT_SPREADSHEET:
				type = InputCreator.ODFType.spreadsheet;
				break;
			}
			for (TestType test : t.getTest()) {
				testreports.add(runTest(target, test, type));
			}
		}
		return testreports;
	}

	public TestreportType runTest(TargetType target, TestType test, ODFType type) {
		TestreportType report = new TestreportType();
		System.out.println(target.getName() + " " + test.getName());
		System.out.flush();
		InputCreator creator = new InputCreator(type, ODFVersion.v1_2);
		String path = creator.createInput(test.getInput());
		InputReportType inputReport = new InputReportType();
		inputReport.setValidation(outputchecker.check(path));
		//for (CommandType cmd : target.getCommand()) {
		//	path = runCommand(cmd, path);
		//}
		(new File(path)).delete();
		return report;
	}

	public String runCommand(CommandType command, String inpath) {
		String cmd[] = new String[command.getInfileOrOutfileOrArgument().size() + 1];
		String outpath = inpath;
		cmd[0] = command.getExe();
		int i = 1;
		for (JAXBElement<?> a : command.getInfileOrOutfileOrArgument()) {
			String name = a.getName().getLocalPart();
			if (a.getValue() instanceof ArgumentType) {
				cmd[i] = ((ArgumentType) a.getValue()).getValue();
			} else if (name.equals("infile")) {
				cmd[i] = inpath;
			} else if (name.equals("outfile")) {
				cmd[i] = outpath = "out.odt";
			}
			++i;
		}
		String env[] = new String[command.getEnv().size()];
		i = 0;
		for (EnvType e : command.getEnv()) {
			String value = System.getenv(e.getName());
			if (e.getValue() != null) {
				value = e.getValue();
			}
			if (value == null) {
				value = "";
			}
			env[i] = e.getName() + "=" + value;
			++i;
		}
		runCommand(cmd, env);
		return outpath;
	}

	private void runCommand(String cmd[], String env[]) {
		try {
			String line;
			Process p = Runtime.getRuntime().exec(cmd, env);
			BufferedReader bri = new BufferedReader(new InputStreamReader(
					p.getInputStream()));
			BufferedReader bre = new BufferedReader(new InputStreamReader(
					p.getErrorStream()));
			while ((line = bri.readLine()) != null) {
				System.err.println(line);
			}
			bri.close();
			while ((line = bre.readLine()) != null) {
				System.err.println(line);
			}
			bre.close();
			p.waitFor();
		} catch (Exception err) {
			err.printStackTrace();
		}
	}
}
