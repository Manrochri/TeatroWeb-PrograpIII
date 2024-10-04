package modelo;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConnection() {
        Connection con = null;
        try {
            // Cargar el driver JDBC
            Class.forName("com.mysql.cj.jdbc.Driver"); // Asegúrate de tener el driver correcto

            // Establecer la conexión
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/teatroweb", 
                "root", 
                ""
            );
        } catch(Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}
