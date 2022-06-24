package ca.jrvs.apps.grep;

import org.apache.log4j.BasicConfigurator;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class JavaGrepLambdaImp extends JavaGrepImp{

    public static void main(String[] args) {
        if (args.length != 3) {
            throw new IllegalArgumentException("Usage: JavaGrep regex rootPath outFile");
        }
        BasicConfigurator.configure();
        JavaGrepLambdaImp javaGrepLambdaImp = new JavaGrepLambdaImp();
        javaGrepLambdaImp.setRegex(args[0]);
        javaGrepLambdaImp.setRootPath(args[1]);
        javaGrepLambdaImp.setOutFile(args[2]);
        try {
            javaGrepLambdaImp.process();
        } catch (Exception ex) {
            javaGrepLambdaImp.logger.error("Process Failed", ex);
        }
    }

    @Override

    public List<File> listFiles(String rootDir) {
        try {
            Stream<File> filenames = Files.walk(Paths.get(rootDir))
                    .filter(Files::isRegularFile)
                    .map(Path::toFile);

            return filenames.collect(Collectors.toList());
        } catch (IOException e) {
            throw new IllegalArgumentException("Input data source is wrong");
        }
    }

    @Override
    public List<String> readLines(File inpputfile) {
        List<String> list = new ArrayList<>();

        try
        {
            Stream<String> stream = Files.lines(inpputfile.toPath());
            {
                list = stream.collect(Collectors.toList());
            }
        } catch (FileNotFoundException e) {
            logger.error("FileNotFoundException", e);
        }
        catch (IOException e) {
            logger.error("IOException", e);

        }
        return list;
    }
}
