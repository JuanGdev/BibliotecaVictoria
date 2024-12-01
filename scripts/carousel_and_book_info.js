document.addEventListener('DOMContentLoaded', () => {
    // Carousel functionality
    const slides = document.querySelectorAll('.carrusel .slide');
    let currentIndex = 0;

    function showSlide(index) {
        slides.forEach((slide, i) => {
            slide.style.transform = `translateX(${(i - index) * 100}%)`;
        });
    }

    function nextSlide() {
        currentIndex = (currentIndex + 1) % slides.length;
        showSlide(currentIndex);
    }

    setInterval(nextSlide, 3000);

    // Add click event to move carousel manually
    const nextButton = document.createElement('div');
    nextButton.innerHTML = '>';
    nextButton.style.position = 'absolute';
    nextButton.style.right = '10px';
    nextButton.style.top = '50%';
    nextButton.style.transform = 'translateY(-50%)';
    nextButton.style.cursor = 'pointer';
    nextButton.style.fontSize = '2em';
    nextButton.style.color = '#333';
    nextButton.addEventListener('click', nextSlide);

    document.querySelector('.carrusel').appendChild(nextButton);

    // Initialize the carousel
    showSlide(currentIndex);

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

                genres[genre].forEach(book => {
                    const libro = document.createElement('div');
                    libro.classList.add('libro');
                    libro.style.setProperty('--book-color', getRandomColor());
                    libro.textContent = book.titulo;
                    libro.setAttribute('data-info', JSON.stringify(book));
                    librero.appendChild(libro);
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

            // Handle book click event
            const books = document.querySelectorAll('.libro');
            const bookInfoPanel = document.querySelector('.book-info-panel');
            books.forEach(book => {
                book.addEventListener('click', () => {
                    const info = JSON.parse(book.getAttribute('data-info'));
                    document.getElementById('libro_id').textContent = info.libro_id;
                    document.getElementById('sinopsis').textContent = info.sinopsis;
                    document.getElementById('autor').textContent = info.autor;
                    document.getElementById('editorial').textContent = info.editorial;
                    document.getElementById('anio').textContent = info.ano_publicacion;
                    document.getElementById('edicion').textContent = info.edicion;
                    document.getElementById('isbn').textContent = info.ISBN;
                    bookInfoPanel.classList.add('open');
                    
                    // Add event listener for the loan button
                    document.getElementById('pedir-btn').onclick = () => {
                        fetch('../backend/create_loan.php', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                            body: JSON.stringify({
                                libro_id: info.libro_id
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
                    };
                });
            });
        });

    function getRandomColor() {
        const colors = ['#4CAF50', '#FF5722', '#2196F3', '#FFC107', '#9C27B0'];
        return colors[Math.floor(Math.random() * colors.length)];
    }
});