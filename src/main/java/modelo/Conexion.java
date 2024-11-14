package modelo;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConnection() {
        Connection con = null;
        try {
      
            Class.forName("com.mysql.cj.jdbc.Driver"); 

            // Establecer la conexión
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/teatroweb", 
                "root", 
                "shadowsun456"
            );
        } catch(Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}
