
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
});