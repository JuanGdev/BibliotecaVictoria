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
            espacioDiv.setAttribute('data-id', espacio.espacio_id); // Add data-id attribute
            espacioDiv.innerHTML = `
                <div style="padding: 10px; background-color: ${espacio.disponibilidad === 'disponible' ? 'green' : 'red'};">
                    <h3>${espacio.nombre_espacio}</h3>
                    <p>${espacio.descripcion}</p>
                    <button onclick="toggleReserva(${espacio.espacio_id}, '${espacio.disponibilidad}')">
                        ${espacio.disponibilidad === 'disponible' ? 'Reservar' : 'Liberar'}
                    </button>
                </div>
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
            const espacioDiv = document.querySelector(`.espacio[data-id="${espacioId}"]`);
            if (espacioDiv) {
                espacioDiv.classList.remove('disponible', 'ocupado'); // Remove existing classes
                espacioDiv.classList.add(action === 'reservar' ? 'ocupado' : 'disponible'); // Add new class
                espacioDiv.querySelector('button').innerText = action === 'reservar' ? 'Liberar' : 'Reservar'; // Update button text
            }
        } else {
            alert('Error al cambiar la reserva');
        }
    } catch (error) {
        console.error('Error toggling reserva:', error);
    }
}