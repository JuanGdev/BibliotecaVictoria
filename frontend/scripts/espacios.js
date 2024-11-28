document.addEventListener('DOMContentLoaded', () => {
    fetchEspacios();
    fetchEspaciosAdmin();
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
                    <p><strong>Capacidad:</strong> ${espacio.capacidad} personas</p>
                    <p><strong>Ubicación:</strong> ${espacio.ubicacion}</p>
                    <p>Equipamiento: ${espacio.equipamiento}</p>
                    <button style="background-color: ${espacio.disponibilidad === 'disponible' ? 'green' : 'red'};" onclick="toggleReserva(${espacio.espacio_id}, '${espacio.disponibilidad}')">
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

async function fetchEspaciosAdmin() {
    try {
        const response = await fetch('../backend/get_espacios.php');
        const espacios = await response.json();
        const container = document.getElementById('space-table-body');
        container.innerHTML = '';

        espacios.forEach(espacio => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${espacio.espacio_id}</td>
                <td>${espacio.nombre_espacio}</td>
                <td>${espacio.tipo_espacio}</td>
                <td>${espacio.capacidad}</td>
                <td>${espacio.ubicacion}</td>
                <td>${espacio.disponibilidad}</td>
                <td>
                    <button class="btn btn-warning btn-sm" onclick="showEditSpaceModal(${espacio.espacio_id})">Editar</button>
                    <button class="btn btn-danger btn-sm" onclick="deleteSpace(${espacio.espacio_id})">Eliminar</button>
                </td>
            `;
            container.appendChild(row);
        });
    } catch (error) {
        console.error('Error fetching espacios:', error);
    }
}

function showAddSpaceModal() {
    document.getElementById('space-form').reset();
    document.getElementById('space-id').value = '';
    document.getElementById('spaceModalTitle').innerText = 'Agregar Espacio';
    document.getElementById('spaceModal').classList.add('show');
}

function showEditSpaceModal(id) {
    fetch(`../backend/get_space.php?id=${id}`)
        .then(response => response.json())
        .then(espacio => {
            document.getElementById('space-id').value = espacio.espacio_id;
            document.getElementById('nombre_espacio').value = espacio.nombre_espacio;
            document.getElementById('tipo_espacio').value = espacio.tipo_espacio;
            document.getElementById('capacidad').value = espacio.capacidad;
            document.getElementById('ubicacion').value = espacio.ubicacion;
            document.getElementById('descripcion').value = espacio.descripcion;
            document.getElementById('equipamiento').value = espacio.equipamiento;
            document.getElementById('disponibilidad').value = espacio.disponibilidad;
            document.getElementById('spaceModalTitle').innerText = 'Editar Espacio';
            document.getElementById('spaceModal').classList.add('show');
        });
}

document.getElementById('space-form').addEventListener('submit', function (event) {
    event.preventDefault();
    const formData = new FormData(this);
    const id = document.getElementById('space-id').value;
    const url = id ? `../backend/update_space.php?id=${id}` : '../backend/add_space.php';
    fetch(url, {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                fetchEspaciosAdmin();
                fetchEspacios(); // Refresh the list of spaces available for reservation
                document.getElementById('spaceModal').classList.remove('show');
            } else {
                alert('Error al guardar el espacio');
            }
        });
});

function deleteSpace(id) {
    if (confirm('¿Estás seguro de que deseas eliminar este espacio?')) {
        fetch(`../backend/delete_space.php?id=${id}`)
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    fetchEspaciosAdmin();
                    fetchEspacios(); // Refresh the list of spaces available for reservation
                } else {
                    alert('Error al eliminar el espacio');
                }
            });
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
                const newDisponibilidad = action === 'reservar' ? 'ocupado' : 'disponible';
                espacioDiv.classList.remove('disponible', 'ocupado'); // Remove existing classes
                espacioDiv.classList.add(newDisponibilidad); // Add new class
                espacioDiv.querySelector('button').innerText = newDisponibilidad === 'disponible' ? 'Reservar' : 'Liberar'; // Update button text
                espacioDiv.querySelector('button').style.backgroundColor = newDisponibilidad === 'disponible' ? 'green' : 'red'; // Update button color
                espacioDiv.querySelector('div').style.backgroundColor = newDisponibilidad === 'disponible' ? 'green' : 'red'; // Update nested div background color
                espacioDiv.querySelector('button').setAttribute('onclick', `toggleReserva(${espacioId}, '${newDisponibilidad}')`); // Update onclick attribute
            }
        } else {
            alert('Error al cambiar la reserva');
        }
    } catch (error) {
        console.error('Error toggling reserva:', error);
    }
}