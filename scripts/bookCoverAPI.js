async function getBookCover(isbn) {
    const url = `https://www.googleapis.com/books/v1/volumes?q=isbn:${isbn}`;
    
    try {
        const response = await fetch(url);
        const data = await response.json();
        
        if (data.items && data.items[0] && data.items[0].volumeInfo.imageLinks) {
            // Get the largest image available
            const imageLinks = data.items[0].volumeInfo.imageLinks;
            return imageLinks.thumbnail || imageLinks.smallThumbnail;
        }
        return null;
    } catch (error) {
        console.error('Error fetching book cover:', error);
        return null;
    }
}
