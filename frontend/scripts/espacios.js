document.addEventListener('DOMContentLoaded', () => {
    fetchEspacios();
});

async function fetchEspacios() {
    try {
        const response = await fetch('../backend/get_espacios.php');
        const espacios = await response.json();
        const container = document.getElementById('espacios-container');
        container.innerHTML = '';

        espacios.forEach(espacio => {
            const espacioDiv = document.createElement('div');
            espacioDiv.className = `espacio ${espacio.disponibilidad}`;
            espacioDiv.innerHTML = `
                <h3>${espacio.nombre_espacio}</h3>
                <p>${espacio.descripcion}</p>
                <button onclick="toggleReserva(${espacio.espacio_id}, '${espacio.disponibilidad}')">
                    ${espacio.disponibilidad === 'disponible' ? 'Reservar' : 'Liberar'}
                </button>
            `;
            container.appendChild(espacioDiv);
        });
    } catch (error) {
        console.error('Error fetching espacios:', error);
    }
}

async function toggleReserva(espacioId, disponibilidad) {
    try {
        const action = disponibilidad === 'disponible' ? 'reservar' : 'liberar';
        const response = await fetch(`../backend/toggle_reserva.php?action=${action}&espacio_id=${espacioId}`);
        const result = await response.json();

        if (result.success) {
            fetchEspacios();
        } else {
            alert('Error al cambiar la reserva');
        }
    } catch (error) {
        console.error('Error toggling reserva:', error);
    }
}