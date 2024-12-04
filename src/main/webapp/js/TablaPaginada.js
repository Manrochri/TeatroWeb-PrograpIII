function paginacionTabla(
    tablaId, 
    itemsPorPagina = 5, 
    paginacionId = 'paginacion'
) {
    // Verificar si la tabla existe
    const tabla = document.getElementById(tablaId);
    if (!tabla) {
        console.warn(`Tabla con ID ${tablaId} no encontrada`);
        return;
    }

    // Verificar si hay filas en el tbody
    const filas = Array.from(tabla.querySelectorAll('tbody tr'));
    if (filas.length === 0) {
        console.warn(`No hay filas en la tabla ${tablaId}`);
        return;
    }

    const totalFilas = filas.length;
    const totalPaginas = Math.ceil(totalFilas / itemsPorPagina);
    let paginaActual = 1;

    function mostrarPagina(pagina) {
        const inicio = (pagina - 1) * itemsPorPagina;
        const fin = inicio + itemsPorPagina;

        // Ocultar todas las filas
        filas.forEach(fila => fila.style.display = 'none');

        // Mostrar filas de la página actual
        filas.slice(inicio, fin).forEach(fila => {
            fila.style.display = '';
        });

        actualizarBotonesPaginacion();
    }

    function actualizarBotonesPaginacion() {
        const paginacion = document.getElementById(paginacionId);
        if (!paginacion) {
            console.warn(`Contenedor de paginación con ID ${paginacionId} no encontrado`);
            return;
        }

        paginacion.innerHTML = `
            <nav aria-label="Page navigation">
                <ul class="pagination">
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

        // Añadir event listeners
        const paginacionContainer = document.getElementById(paginacionId);
        paginacionContainer.querySelectorAll('.page-link').forEach(boton => {
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

    // Inicializar primera página
    mostrarPagina(1);
}

function observarTabla(tablaId, contenedorId, itemsPorPagina = 5, paginacionId = 'paginacion') {
    const targetNode = document.getElementById(contenedorId); 
    
    const config = { childList: true, subtree: true };
    
    const callback = function(mutationsList, observer) {
        for(let mutation of mutationsList) {
            if (mutation.type === 'childList') {
                const tabla = document.getElementById(tablaId);
                if (tabla) {
                    paginacionTabla(tablaId, itemsPorPagina, paginacionId);
                    // Desconectar el observador después de encontrar la tabla
                    observer.disconnect();
                }
            }
        }
    };

    const observer = new MutationObserver(callback);
    observer.observe(targetNode, config);
}

// Iniciar observación cuando el DOM esté completamente cargado
document.addEventListener('DOMContentLoaded', () => {
    // Observar tabla de usuarios
    console.log("Numeración de tabla cargado");



    // Ejemplo: Observar otra tabla (si la tienes)
    // observarTabla('tablaPerfiles', 'seccionCRUD', 10, 'paginacionPerfiles');
});