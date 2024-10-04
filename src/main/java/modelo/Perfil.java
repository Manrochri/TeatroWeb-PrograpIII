package modelo;

public class Perfil {
    private int idPerfil;
    private String nombre;
    private String descripcion;
    private boolean estadoRegistro;

    // Getters y Setters
    public int getIdPerfil() {
        return idPerfil;
    }
    public void setIdPerfil(int idPerfil) {
        this.idPerfil = idPerfil;
    }
    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    public String getDescripcion() {
        return descripcion;
    }
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    public boolean isEstadoRegistro() {
        return estadoRegistro;
    }
    public void setEstadoRegistro(boolean estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
}
