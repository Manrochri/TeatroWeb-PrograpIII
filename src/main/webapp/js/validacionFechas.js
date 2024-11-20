/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

window.onload = function() {
    // fecha actual
    const today = new Date();
    // Restar 5 días a la fecha actual
    today.setDate(today.getDate() - 5);

    // Formatear la fecha como 'YYYY-MM-DD' para el campo de tipo 'date'
    const minDate = today.toISOString().split("T")[0];

    // Establecer la fecha mínima para el campo de tipo 'date'
    document.getElementById("fechaSesion").setAttribute("min", minDate);
};

