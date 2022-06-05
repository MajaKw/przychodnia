package bazy.przychodnia;

import java.sql.*;

public class Database {
    private final String url = "jdbc:postgresql://localhost:5432/maisho"; // jdbc:postgresql://server-name:server-port/database-name
    private final String user = "maisho";
    private final String password = "Piesiu111.";

    public Connection connect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to the PostgreSQL server successfully.");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return conn;
    }

    public static void printJans(ResultSet rs) throws SQLException {
        while(rs.next()){
            System.out.println(rs.getString("owner_id") + " " +
                    rs.getString("adres") + " " +
                    rs.getString("name") + " " +
                    rs.getString("income")
            );
        }
    }

    public static void main(String[] args) {
        Database app = new Database();
//        app.connect();
        String SQLquery = "SELECT *" +
                "FROM owner_house JOIN houses USING (house_id) JOIN owners USING (owner_id) " +
                "WHERE name='JAN'";
        try(Connection conn = app.connect();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(SQLquery)) {
            printJans(rs);
        } catch(SQLException e){
            System.out.println(e.getMessage());
        }
    }
}
