


window.onload = function() {
    var mensaje = document.getElementById('mensaje').value;
    var tipo = document.getElementById('tipo').value;

    if (mensaje && tipo) {
        var modalBody = document.getElementById("modalBody");
        modalBody.innerHTML = mensaje;

        // Inicializa y muestra el modal de Bootstrap
        var modal = new bootstrap.Modal(document.getElementById('statusModal'));
        modal.show();
    }
}
