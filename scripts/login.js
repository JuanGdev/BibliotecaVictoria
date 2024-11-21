
document.getElementById('login-form').addEventListener('submit', function(event) {
    event.preventDefault();
    const formData = new FormData(this);
    fetch('../backend/login.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        const loginMessage = document.getElementById('login-message');
        if (data.status === 'success') {
            loginMessage.textContent = data.message;
            loginMessage.classList.add('text-success');
            loginMessage.classList.remove('text-danger');
        } else {
            loginMessage.textContent = data.message;
            loginMessage.classList.add('text-danger');
            loginMessage.classList.remove('text-success');
        }
    });
});