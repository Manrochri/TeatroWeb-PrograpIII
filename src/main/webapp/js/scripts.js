// Validar que la contraseña y la confirmación coincidan
function validarFormulario(event) {
    var clave = document.getElementById("clave").value;
    var confirmarClave = document.getElementById("confirmarClave").value;

    if (clave !== confirmarClave) {
        alert("Las contraseñas no coinciden. Por favor, inténtelo de nuevo.");
        event.preventDefault(); // Evitar que el formulario se envíe
    }
}