<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="styles/styles.css">
    </head>
    <body>
        <div class="container mt-5 pt-5 d-flex justify-content-center">
        <div class="form-container">
            <h2 class="text-center">Login</h2>
            
                <form action="LoginServlet" method="post">
                    <div class="mb-3">
                        <label for="usuario" class="form-label">DNI o Correo</label>
                        <input type="text" class="form-control" id="usuario" name="usuario" required>
                    </div>
                    <div class="mb-3">
                        <label for="clave" class="form-label">Clave</label>
                        <input type="password" class="form-control" id="clave" name="clave" required>
                    </div>
                    <div class="mt-4">
                    <button type="submit" class="btn btn-primary">Iniciar Sesión</button>
                    </div>
                    <div class="mt-4">
                    <a href="index.jsp" class="boton">¿No tienes cuenta? Regístrate</a>
                    </div>
                </form>
            </div>
    </div>
    </body>
</html>
