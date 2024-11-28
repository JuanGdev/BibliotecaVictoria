document.addEventListener('DOMContentLoaded', function() {
    fetchUsers();
    fetchBooks();

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

    document.getElementById('book-form').addEventListener('submit', function (event) {
        event.preventDefault();
        const formData = new FormData(this);
        const id = document.getElementById('book-id').value;
        const url = id ? `../backend/update_book.php?id=${id}` : '../backend/add_book.php';
        fetch(url, {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(result => {
            if (result.status === 'success') {
                fetchBooks();
                document.getElementById('bookModal').classList.remove('show');
            } else {
                alert('Error al guardar el libro');
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

async function fetchBooks() {
    try {
        const response = await fetch('../backend/get_books.php');
        const books = await response.json();
        const container = document.getElementById('book-table-body');
        container.innerHTML = '';

        books.forEach(book => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${book.libro_id}</td>
                <td>${book.titulo}</td>
                <td>${book.autor}</td>
                <td>${book.genero}</td>
                <td>${book.editorial}</td>
                <td>${book.edicion}</td>
                <td>${book.ISBN}</td>
                <td>${book.ano_publicacion}</td>
                <td>${book.idioma}</td>
                <td>${book.estado}</td>
                <td>${book.cantidad}</td>
                <td>
                    <button class="btn btn-warning btn-sm" onclick="showEditBookModal(${book.libro_id})">Editar</button>
                    <button class="btn btn-danger btn-sm" onclick="deleteBook(${book.libro_id})">Eliminar</button>
                </td>
            `;
            container.appendChild(row);
        });
    } catch (error) {
        console.error('Error fetching books:', error);
    }
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

function showAddBookModal() {
    document.getElementById('book-form').reset();
    document.getElementById('book-id').value = '';
    document.getElementById('bookModalTitle').innerText = 'Agregar Libro';
    document.getElementById('bookModal').classList.add('show');
}

function showEditBookModal(id) {
    fetch(`../backend/get_book.php?id=${id}`)
    .then(response => response.json())
    .then(book => {
        document.getElementById('book-id').value = book.libro_id;
        document.getElementById('titulo').value = book.titulo;
        document.getElementById('autor').value = book.autor;
        document.getElementById('genero').value = book.genero;
        document.getElementById('editorial').value = book.editorial;
        document.getElementById('edicion').value = book.edicion;
        document.getElementById('isbn').value = book.ISBN;
        document.getElementById('ano_publicacion').value = book.ano_publicacion;
        document.getElementById('idioma').value = book.idioma;
        document.getElementById('estado').value = book.estado;
        document.getElementById('cantidad').value = book.cantidad;
        document.getElementById('bookModalTitle').innerText = 'Editar Libro';
        document.getElementById('bookModal').classList.add('show');
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

function deleteBook(id) {
    if (confirm('¿Estás seguro de que deseas eliminar este libro?')) {
        fetch(`../backend/delete_book.php?id=${id}`)
        .then(response => response.json())
        .then(result => {
            if (result.status === 'success') {
                fetchBooks();
            } else {
                alert('Error al eliminar el libro');
            }
        });
    }
}