document.addEventListener('DOMContentLoaded', () => {
    // Fetch and display books
    fetch('../backend/get_books.php')
        .then(response => response.json())
        .then(data => {
            const libreroContainer = document.getElementById('librero-container');
            const genres = {};

            data.forEach(book => {
                if (!genres[book.genero]) {
                    genres[book.genero] = [];
                }
                genres[book.genero].push(book);
            });

            for (const genre in genres) {
                const librero = document.createElement('div');
                librero.classList.add('librero');

                // Create all books for this genre first
                const bookPromises = genres[genre].map(async book => {
                    const libro = document.createElement('div');
                    libro.classList.add('libro');
                    libro.style.setProperty('--book-color', getRandomColor());
                    
                    const coverContainer = document.createElement('div');
                    coverContainer.classList.add('book-cover-container');
                    
                    const coverUrl = await getBookCover(book.ISBN);
                    if (coverUrl) {
                        const coverImg = document.createElement('img');
                        coverImg.src = coverUrl;
                        coverImg.alt = book.titulo;
                        coverImg.classList.add('book-cover');
                        coverContainer.appendChild(coverImg);
                    }

                    const titleDiv = document.createElement('div');
                    titleDiv.textContent = book.titulo;
                    titleDiv.classList.add('book-title');
                    coverContainer.appendChild(titleDiv);

                    libro.appendChild(coverContainer);
                    libro.setAttribute('data-info', JSON.stringify(book));

                    // Add click event listener for each book
                    libro.addEventListener('click', (e) => {
                        e.stopPropagation();
                        const info = JSON.parse(libro.getAttribute('data-info'));
                        const bookInfoPanel = document.querySelector('.book-info-panel');
                        
                        document.getElementById('libro_id').textContent = info.libro_id;
                        document.getElementById('sinopsis').textContent = info.sinopsis;
                        document.getElementById('autor').textContent = info.autor;
                        document.getElementById('editorial').textContent = info.editorial;
                        document.getElementById('anio').textContent = info.ano_publicacion;
                        document.getElementById('edicion').textContent = info.edicion;
                        document.getElementById('isbn').textContent = info.ISBN;
                        bookInfoPanel.classList.add('open');
                    });

                    return libro;
                });

                // Wait for all books to be created
                Promise.all(bookPromises).then(books => {
                    books.forEach(libro => librero.appendChild(libro));
                });

                const baseMadera = document.createElement('div');
                baseMadera.classList.add('base-madera');
                const categoria = document.createElement('div');
                categoria.classList.add('categoria');
                categoria.textContent = genre;
                baseMadera.appendChild(categoria);
                librero.appendChild(baseMadera);

                libreroContainer.appendChild(librero);
            }

            // Add event listener for the loan button
            document.getElementById('pedir-btn').addEventListener('click', function() {
                const libro_id = document.getElementById('libro_id').textContent;
                fetch('../backend/create_loan.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        libro_id: libro_id
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        alert('Libro solicitado exitosamente');
                    } else {
                        alert('Error al solicitar el libro: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error al procesar la solicitud');
                });
            });
        });

    function getRandomColor() {
        const colors = ['#4CAF50', '#FF5722', '#2196F3', '#FFC107', '#9C27B0'];
        return colors[Math.floor(Math.random() * colors.length)];
    }
});

// Add click event listener to close panel when clicking outside
document.addEventListener('click', function(event) {
    const bookInfoPanel = document.querySelector('.book-info-panel');
    const isClickInside = bookInfoPanel.contains(event.target);
    const isBookClick = event.target.closest('.libro');
    
    // Only close if click is outside panel and not on a book
    if (!isClickInside && !isBookClick && bookInfoPanel.classList.contains('open')) {
        bookInfoPanel.classList.remove('open');
    }
});