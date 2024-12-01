document.addEventListener('DOMContentLoaded', function() {
    loadCart();
});

function loadCart() {
    let cart = JSON.parse(localStorage.getItem('cart')) || [];
    let cartTableBody = document.getElementById('cart-table-body');
    cartTableBody.innerHTML = '';

    if (cart.length === 0) {
        cartTableBody.innerHTML = '<tr><td colspan="3">El carrito está vacío.</td></tr>';
        return;
    }

    cart.forEach(libro_id => {
        fetch(`../backend/get_book_info.php?libro_id=${libro_id}`)
        .then(response => response.json())
        .then(book => {
            if (book) {
                let row = document.createElement('tr');
                row.innerHTML = `
                    <td>${book.titulo || 'N/A'}</td>
                    <td>${book.autor || 'N/A'}</td>
                    <td><button class="btn btn-danger btn-sm" onclick="removeFromCart(${libro_id})">Eliminar</button></td>
                `;
                cartTableBody.appendChild(row);
            }
        })
        .catch(error => console.error('Error:', error));
    });
}

function removeFromCart(libro_id) {
    let cart = JSON.parse(localStorage.getItem('cart')) || [];
    cart = cart.filter(id => id != libro_id);
    localStorage.setItem('cart', JSON.stringify(cart));
    loadCart();
}

document.getElementById('submit-loan').addEventListener('click', function() {
    let cart = JSON.parse(localStorage.getItem('cart')) || [];
    if (cart.length === 0) {
        alert('El carrito está vacío.');
        return;
    }
    // Enviar la solicitud de préstamo al backend
    fetch('../backend/reserve_book.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ libro_ids: cart })
    })
    .then(response => response.json())
    .then(data => {
        alert(data.message);
        if (data.status === 'success') {
            // Vaciar el carrito y recargar la página
            localStorage.removeItem('cart');
            loadCart();
        }
    })
    .catch(error => console.error('Error:', error));
});