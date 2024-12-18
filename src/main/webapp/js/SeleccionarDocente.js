// Función para seleccionar un usuario y pasar sus datos al formulario de la columna izquierda
function seleccionarDocenteUsuario(idUsuario, dni, nombres, apellidoPaterno) {
  // Asignar el ID del usuario seleccionado al campo oculto del formulario
  document.getElementById('idUsuarioDocente').value = idUsuario;


  // Mostrar solo el nombre completo (nombre + apellido paterno) en el campo de búsqueda (solo lectura)
  document.getElementById("searchDocente").value = `${nombres} ${apellidoPaterno}`;

  // Cerrar el modal de búsqueda de usuarios
  const usuarioModal = bootstrap.Modal.getInstance(document.getElementById("usuarioModal2"));
  if (usuarioModal) {
    usuarioModal.hide();
  }
}
