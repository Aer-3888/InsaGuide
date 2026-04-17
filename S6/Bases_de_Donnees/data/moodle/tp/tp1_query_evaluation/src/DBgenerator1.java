import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Random;
import java.util.UUID;

/**
 * DBgenerator1 - Generates a large SQL database with customer and invoice data
 *
 * Purpose: Create realistic facture (invoice) and customer tables for testing
 *          complex JOIN queries and optimization strategies
 *
 * Usage: java DBgenerator1 [size]
 *        where size = number of customer-invoice pairs to generate (default: 6,000,000)
 *
 * Output: database1.sql file containing:
 *         - Two tables: facture (invoice) and customer
 *         - Each customer has exactly one invoice
 *         - Invoice amounts range from 0 to 1000.01 euros
 *         - UUIDs used for customerId and customer names for realistic data volume
 *
 * Schema:
 *         facture (factureId INTEGER, customerId TEXT, amount REAL)
 *         customer (customerId TEXT, name TEXT)
 *
 * Example: java DBgenerator1 1000000
 *          Generates 1 million customers with 1 million invoices
 */
public class DBgenerator1 {

    public static void main(String[] args) {
        System.out.println("DBgenerator1");

        try {
            // Default size: 6 million rows
            int size = 6000000;

            // Parse command-line argument for custom size
            try {
                size = Integer.parseInt(args[0]);
            } catch (NumberFormatException e) {
                System.err.println("Argument must be an integer");
                System.exit(1);
            } catch (ArrayIndexOutOfBoundsException e) {
                // Use default size if no argument provided
            }

            String content;
            Random randomGenerator = new Random();
            File file = new File("database1.sql");

            // Create file if it doesn't exist
            if (!file.exists()) {
                file.createNewFile();
            }

            // Open file writer with buffering for performance
            FileWriter fw = new FileWriter(file.getAbsoluteFile());
            BufferedWriter bw = new BufferedWriter(fw);

            String rand;
            String uuid;
            String amt;

            // Disable automatic index creation to test raw query performance
            content = "PRAGMA auto_index = 0;\n";
            bw.write(content);

            // Begin transaction for bulk insert performance
            content = "BEGIN TRANSACTION;\n";
            bw.write(content);

            // Create facture (invoice) table
            content = "CREATE TABLE facture (factureId INTEGER, customerId TEXT, amount REAL);\n";
            bw.write(content);

            // Create customer table
            content = "CREATE TABLE customer (customerId TEXT, name TEXT);\n";
            bw.write(content);

            // Generate customer-invoice pairs
            for(int i=0; i<size; i++) {
                // Generate unique customer ID (UUID format)
                rand = UUID.randomUUID().toString();

                // Generate random customer name (UUID format)
                uuid = UUID.randomUUID().toString();

                // Generate random invoice amount (0.00 to 1000.01 euros, 2 decimal places)
                amt = Double.toString(Math.round(randomGenerator.nextDouble()*1000.01*100.0)/100.0);

                // Insert invoice record
                bw.write("INSERT INTO facture (customerId,amount) VALUES(" +
                        "'" + rand + "'" + ", " + amt
                        +");"
                        + "\n");

                // Insert corresponding customer record
                bw.write("INSERT INTO customer (customerId,name) VALUES(" +
                        "'" + rand + "'" + ", " +"'" +uuid + "'"
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
