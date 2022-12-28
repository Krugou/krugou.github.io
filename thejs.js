
fetch('https://api.github.com/users/Krugou/repos')
    .then(response => response.json())
    .then(data => {
        const main = document.querySelector('main');
        const header = document.querySelector('header');
        const link = 'https://krugou.github.io/'
        data.forEach(repo => {
            // if name is github github-slideshow then skip
            if (repo.name === 'github-slideshow' || repo.name === 'krugou.github.io') {
                return;
            }
            if (repo.has_pages) {
                // make card
                const card = document.createElement('div');
                card.classList.add('card');
                main.appendChild(card);
                // make link
                const link = document.createElement('a');
                link.setAttribute('href', link+repo.name);
                link.textContent = repo.name;
                card.appendChild(link);
               


                
            }
        })
    })
