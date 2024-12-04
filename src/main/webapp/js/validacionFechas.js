/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

function establecerFechaMinima(idFecha) {
    // fecha actual
    const today = new Date();
    today.setDate(today.getDate() - 5);

    // Formatear la fecha como 'YYYY-MM-DD' para el campo de tipo 'date'
    const minDate = today.toISOString().split("T")[0];

    // Obtener el elemento por id
    const campoFecha = document.getElementById(idFecha);

    // Si el campo existe, establecer la fecha mínima
    if (campoFecha) {
        campoFecha.setAttribute("min", minDate);
    }
}

window.onload = function() {
    // Aplicar la fecha mínima a los campos deseados
    establecerFechaMinima("fechaSesion");
    establecerFechaMinima("fechaMatricula");
    // Puedes agregar más campos si lo necesitas
};
