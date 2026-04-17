import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Random;

/**
 * DBgenerator - Generates a large SQL database for testing query performance
 *
 * Purpose: Create a demo table with configurable number of rows for benchmarking
 *          SQLite query execution with and without indexes
 *
 * Usage: java DBgenerator [size]
 *        where size = number of rows to generate (default: 100,000)
 *
 * Output: database.sql file containing:
 *         - CREATE TABLE statement
 *         - INSERT statements with random integer codes
 *         - All wrapped in a transaction for performance
 *
 * Example: java DBgenerator 1000000
 *          Generates 1 million rows in database.sql
 */
public class DBgenerator {

    public static void main(String[] args) {
        System.out.println("DBgenerator");

        try {
            // Default size: 100,000 rows
            int size = 100000;

            // Parse command-line argument for custom size
            try {
                size = Integer.parseInt(args[0]);
            } catch (NumberFormatException e) {
                System.err.println("Argument must be an integer");
                System.exit(1);
            } catch (ArrayIndexOutOfBoundsException e) {
                // Use default size if no argument provided
            }

            // Initialize random number generator
            Random randomGenerator = new Random();
            File file = new File("database.sql");

            // Create file if it doesn't exist
            if (!file.exists()) {
                file.createNewFile();
            }

            // Open file writer with buffering for performance
            FileWriter fw = new FileWriter(file.getAbsoluteFile());
            BufferedWriter bw = new BufferedWriter(fw);

            // Maximum value for random codes (100 million)
            Integer max = 100000000;

            // Write table schema
            String content = "CREATE TABLE demo(id INTEGER PRIMARY KEY, code INTEGER);\n";
            bw.write(content);

            // Begin transaction for bulk insert performance
            // Dramatically faster than individual INSERT commits
            content = "BEGIN TRANSACTION;\n";
            bw.write(content);

            // Optional performance pragmas (commented out)
            // These disable journaling and synchronous writes for maximum speed
            // Trade-off: Less data safety for faster writes
            // content = "PRAGMA journal_mode = OFF;\n";
            // bw.write(content);
            // content = "PRAGMA synchronous = OFF;\n";
            // bw.write(content);

            // Generate INSERT statements with random codes
            for(int i=0; i<size; i++) {
                bw.write("INSERT INTO demo(code) VALUES(" +
                        Integer.toString(randomGenerator.nextInt(max))
                        +");"
                        + "\n");
            }

            // Commit transaction
            content = "COMMIT;\n";
            bw.write(content);
            bw.close();

            System.out.println("Done");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
