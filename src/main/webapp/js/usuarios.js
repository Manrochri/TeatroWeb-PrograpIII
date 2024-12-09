// Variables globales de paginación
let currentPage = 1;
const resultsPerPage = 10;
 
// Función de filtrado y paginación de usuarios
function filtrarUsuarios() {
    const input = document.getElementById('searchUsuario2');
    const filter = input.value.toLowerCase();
    const tabla = document.getElementById('tablaUsuarios2');
    const filas = tabla.querySelectorAll('tbody tr');
 
    let filasVisibles = 0;
 
    filas.forEach(fila => {
        const tdIdUsuario = fila.querySelector('td:nth-child(1)');
        const tdDNI = fila.querySelector('td:nth-child(2)');
        const tdNombre = fila.querySelector('td:nth-child(3)');
 
        if (tdIdUsuario && tdDNI && tdNombre) {
            const txtIdUsuario = tdIdUsuario.textContent.toLowerCase();
            const txtDNI = tdDNI.textContent.toLowerCase();
            const txtNombre = tdNombre.textContent.toLowerCase();
 
            if (
                txtIdUsuario.includes(filter) || 
                txtDNI.includes(filter) || 
                txtNombre.includes(filter)
            ) {
                fila.style.display = '';
                filasVisibles++;
            } else {
                fila.style.display = 'none';
            }
        }
    });
 
    paginacionTabla('tablaUsuarios2', resultsPerPage, 'paginacionUsuarios2');
}
 
// Función de paginación genérica
function paginacionTabla(tablaId, itemsPorPagina = 5, paginacionId = 'paginacion') {
    const tabla = document.getElementById(tablaId);
    const filas = Array.from(tabla.querySelectorAll('tbody tr'))
        .filter(row => row.style.display !== 'none');
    const totalFilas = filas.length;
    const totalPaginas = Math.ceil(totalFilas / itemsPorPagina);
    let paginaActual = 1;
 
    function mostrarPagina(pagina) {
        const inicio = (pagina - 1) * itemsPorPagina;
        const fin = inicio + itemsPorPagina;
 
        filas.forEach(fila => fila.style.display = 'none');
        filas.slice(inicio, fin).forEach(fila => {
            fila.style.display = '';
        });
 
        actualizarBotonesPaginacion();
    }
 
    function actualizarBotonesPaginacion() {
        const paginacion = document.getElementById(paginacionId);
        paginacion.innerHTML = `
<nav aria-label="Navegación de página">
<ul class="pagination justify-content-center">
<li class="page-item ${paginaActual === 1 ? 'disabled' : ''}">
<a class="page-link" href="#" id="btnAnterior-${tablaId}">Anterior</a>
</li>
                    ${[...Array(totalPaginas)].map((_, i) => `
<li class="page-item ${paginaActual === i + 1 ? 'active' : ''}">
<a class="page-link" href="#" data-pagina="${i + 1}">${i + 1}</a>
</li>
                    `).join('')}
<li class="page-item ${paginaActual === totalPaginas ? 'disabled' : ''}">
<a class="page-link" href="#" id="btnSiguiente-${tablaId}">Siguiente</a>
</li>
</ul>
</nav>
        `;
 
        paginacion.querySelectorAll('.page-link').forEach(boton => {
            boton.addEventListener('click', (e) => {
                e.preventDefault();
                if (e.target.id === `btnAnterior-${tablaId}` && paginaActual > 1) {
                    paginaActual--;
                } else if (e.target.id === `btnSiguiente-${tablaId}` && paginaActual < totalPaginas) {
                    paginaActual++;
                } else if (e.target.dataset.pagina) {
                    paginaActual = parseInt(e.target.dataset.pagina);
                }
                mostrarPagina(paginaActual);
            });
        });
    }
 
    mostrarPagina(1);
}
 
function seleccionarUsuario(idUsuario, dni, nombres, apellidoPaterno) {
    console.log('Datos seleccionados:', {
        idUsuario: idUsuario,
        dni: dni,
        nombres: nombres,
        apellidoPaterno: apellidoPaterno
    });

    // Asignar valores al formulario
    const inputIdUsuario = document.getElementById('idUsuario');
    inputIdUsuario.value = idUsuario;
    
    alert(idUsuario);

    const searchDocente = document.getElementById('searchDocente');
    searchDocente.value = `${nombres} ${apellidoPaterno}`.trim();

    console.log('Valor establecido en input:', {
        value: inputIdUsuario.value,
        tipo: typeof inputIdUsuario.value
    });
}

 
document.getElementById('formDocente').addEventListener('submit', function(e) {
    const idUsuario = document.getElementById('idUsuario').value;
    const idGradoAcademico = document.getElementById('idGradoAcademico').value;
    const descripcion = document.getElementById('descripcion').value;
 
    if (!idUsuario || idUsuario.trim() === '') {
        e.preventDefault();
        alert('Por favor, seleccione un usuario');
        return false;
    }
 
    if (!idGradoAcademico || idGradoAcademico === '') {
        e.preventDefault();
        alert('Por favor, seleccione un grado académico');
        return false;
    }
 
    if (!descripcion || descripcion.trim() === '') {
        e.preventDefault();
        alert('Por favor, ingrese una descripción');
        return false;
    }
 
    return true;
});
 
document.addEventListener('DOMContentLoaded', () => {
    paginacionTabla('tablaUsuarios2', resultsPerPage, 'paginacionUsuarios2');
});

