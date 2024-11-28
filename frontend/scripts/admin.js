document.addEventListener('DOMContentLoaded', function() {
    fetchUsers();

    document.getElementById('user-form').addEventListener('submit', function(event) {
        event.preventDefault();
        const formData = new FormData(document.getElementById('user-form'));
        const userId = formData.get('usuario_id');
        const url = userId ? `../backend/update_user.php` : `../backend/add_user.php`;
        const method = userId ? 'POST' : 'POST';

        fetch(url, {
            method: method,
            body: new URLSearchParams(formData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                fetchUsers();
                $('#userModal').modal('hide');
            } else {
                alert(data.message);
            }
        });
    });
});

function fetchUsers() {
    fetch('../backend/get_users.php')
    .then(response => response.json())
    .then(data => {
        const userTableBody = document.getElementById('user-table-body');
        userTableBody.innerHTML = '';
        data.users.forEach(user => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${user.usuario_id}</td>
                <td>${user.nombre}</td>
                <td>${user.apellidos}</td>
                <td>${user.correo}</td>
                <td>${user.tipo_usuario}</td>
                <td>
                    <button class="btn btn-warning btn-sm" onclick="showEditUserModal(${user.usuario_id})">Editar</button>
                    <button class="btn btn-danger btn-sm" onclick="deleteUser(${user.usuario_id})">Eliminar</button>
                </td>
            `;
            userTableBody.appendChild(row);
        });
    });
}

function showAddUserModal() {
    document.getElementById('user-form').reset();
    document.getElementById('user-id').value = '';
    document.getElementById('userModalTitle').innerText = 'Agregar Usuario';
    $('#userModal').modal('show');
}

function showEditUserModal(userId) {
    fetch(`../backend/get_user.php?id=${userId}`)
    .then(response => response.json())
    .then(data => {
        document.getElementById('user-id').value = data.usuario_id;
        document.getElementById('username').value = data.nombre;
        document.getElementById('apellidos').value = data.apellidos;
        document.getElementById('fecha_nacimiento').value = data.fecha_nacimiento;
        document.getElementById('telefono').value = data.telefono;
        document.getElementById('direccion').value = data.direccion;
        document.getElementById('identificacion').value = data.identificacion;
        document.getElementById('comprobante_domicilio').value = data.comprobante_domicilio;
        document.getElementById('fecha_registro').value = data.fecha_registro;
        document.getElementById('email').value = data.correo;
        document.getElementById('estatus').value = data.estatus;
        document.getElementById('registro_caducado').checked = data.registro_caducado;
        document.getElementById('password').value = data.contrasena;
        document.getElementById('user_type').value = data.tipo_usuario;
        document.getElementById('userModalTitle').innerText = 'Editar Usuario';
        $('#userModal').modal('show');
    });
}

function deleteUser(userId) {
    fetch(`../backend/delete_user.php?id=${userId}`, {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            fetchUsers();
        } else {
            alert(data.message);
        }
    });
}