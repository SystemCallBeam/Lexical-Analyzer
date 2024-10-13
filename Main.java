import java.io.FileReader;
import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Usage: java Main <inputfile>");
            return;
        }

        try {
            FileReader reader = new FileReader(args[0]);
            LexicalAnalyzer lexer = new LexicalAnalyzer(reader);

            while (lexer.yylex() != -1) {
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
