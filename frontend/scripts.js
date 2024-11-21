document.addEventListener('DOMContentLoaded', () => {
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

    // Move carousel automatically
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

    // Handle book click event
    const books = document.querySelectorAll('.libro');
    const bookInfoPanel = document.querySelector('.book-info-panel');
    const sinopsis = document.getElementById('sinopsis');
    const autor = document.getElementById('autor');
    const editorial = document.getElementById('editorial');
    const anio = document.getElementById('anio');
    const edicion = document.getElementById('edicion');
    const isbn = document.getElementById('isbn');

    books.forEach(book => {
        book.addEventListener('click', () => {
            const info = JSON.parse(book.getAttribute('data-info'));
            sinopsis.textContent = info.sinopsis;
            autor.textContent = info.autor;
            editorial.textContent = info.editorial;
            anio.textContent = info.anio;
            edicion.textContent = info.edicion;
            isbn.textContent = info.isbn;
            bookInfoPanel.style.display = 'block';
        });
    });
});