<html>
<head>
    <title>Registro de Perfiles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="styles/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/scripts.js"></script>
</head>
<body>
    <div class="container mt-5 d-flex justify-content-center">
        <div class="form-container">
            <h1 class="text-center mb-4">Registro de Nuevo Perfil</h1>
            
            <form action="PerfilServlet" method="post">
                <div class="mb-3 row">
                    <label for="nombre" class="col-sm-3 col-form-label text-end">Nombre del Perfil:</label>
                    <div class="col-sm-9">
                        <input type="text" id="nombre" name="nombre" class="form-control" required>
                    </div>
                </div>
                
                <div class="mb-3 row">
                    <label for="descripcion" class="col-sm-3 col-form-label text-end">Descripción:</label>
                    <div class="col-sm-9">
                        <textarea id="descripcion" name="descripcion" class="form-control"></textarea>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <input type="submit" value="Registrar Perfil" class="btn btn-primary">
                </div>
            </form>
        </div>
    </div>
</body>
</html>
