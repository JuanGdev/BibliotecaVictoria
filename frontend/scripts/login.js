document.getElementById('login-form').addEventListener('submit', function(event) {
    event.preventDefault();
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    fetch('../backend/login.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `email=${email}&password=${password}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            sessionStorage.setItem('userInfo', JSON.stringify(data.user));
            if (data.tipo_usuario === 'admin') {
                window.location.href = 'index_administrador.html';
            } else {
                window.location.href = 'index_usuario.html';
            }
        } else {
            document.getElementById('login-message').innerText = data.message;
        }
    })
    .catch(error => {
        document.getElementById('login-message').innerText = 'Error en el servidor: ' + error.message;
    });
});