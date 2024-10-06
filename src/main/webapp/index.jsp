<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Perfil" %>
<%@ page import="modelo.Conexion" %>
<%@ page import="controlador.PerfilServlet" %>
<!DOCTYPE html>
<html>
    <head>
        <!-- Christian hizo su comentario -->
        <title>Registrar Usuario</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="styles/styles.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/scripts.js"></script>
    </head>
    <body>
        <div class="container mt-5 d-flex justify-content-center">
            <div class="form-container">
                <h1 class="text-center mb-4">Registrar Usuario</h1>

                <!-- Mostrar mensaje de error si existe -->
                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                <div class="alert alert-danger" role="alert">
                    <%= error%>
                </div>
                <%
                    }
                %>

                <form action="registrarUsuario" method="POST" onsubmit="validarFormulario(event)">
                    <div class="mb-3 row">
                        <label for="dni" class="col-sm-3 col-form-label text-end">DNI:</label>
                        <div class="col-sm-9">
                            <input type="text" name="dni" class="form-control" required>
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <label for="nombre" class="col-sm-3 col-form-label text-end">Nombre:</label>
                        <div class="col-sm-9">
                            <input type="text" name="nombre" class="form-control" required>
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <label for="apellidoPaterno" class="col-sm-3 col-form-label text-end">Apellido Paterno:</label>
                        <div class="col-sm-9">
                            <input type="text" name="apellidoPaterno" class="form-control" required>
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <label for="apellidoMaterno" class="col-sm-3 col-form-label text-end">Apellido Materno:</label>
                        <div class="col-sm-9">
                            <input type="text" name="apellidoMaterno" class="form-control">
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <label for="celular" class="col-sm-3 col-form-label text-end">Celular:</label>
                        <div class="col-sm-9">
                            <input type="text" name="celular" class="form-control">
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <label for="correoElectronico" class="col-sm-3 col-form-label text-end">Correo Electrónico:</label>
                        <div class="col-sm-9">
                            <input type="email" name="correoElectronico" class="form-control" required>
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <label for="clave" class="col-sm-3 col-form-label text-end">Clave:</label>
                        <div class="col-sm-9">
                            <input type="password" name="clave" id="clave" class="form-control" required>
                        </div>
                    </div>

                    <!-- Campo adicional para confirmar la clave -->
                    <div class="mb-3 row">
                        <label for="confirmarClave" class="col-sm-3 col-form-label text-end">Confirmar Clave:</label>
                        <div class="col-sm-9">
                            <input type="password" id="confirmarClave" class="form-control" required>
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <label for="perfil" class="col-sm-3 col-form-label text-end">Perfil:</label>
                        <div class="col-sm-9">
                            <select name="perfil" class="form-select" required>
                                <option value="">Seleccione un perfil</option>
                                <%-- Aquí debes asegurarte de que los perfiles se carguen correctamente --%>
                                <%
                                    List<Perfil> perfiles = (List<Perfil>) request.getAttribute("perfiles");
                                    if (perfiles != null) {
                                        for (Perfil perfil : perfiles) {
                                %>
                                <option value="<%= perfil.getIdPerfil()%>"><%= perfil.getNombre()%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <input type="submit" value="Registrar Usuario" class="btn btn-primary">
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>