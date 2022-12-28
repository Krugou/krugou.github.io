const fetchrepos = () => {
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



                    // Add repo name and description
                    const link = document.createElement('a');
                    link.setAttribute('href', link + repo.name);
                    link.textContent = repo.name;
                    card.appendChild(link);

                    const description = document.createElement('p');
                    description.textContent = repo.description;
                    card.appendChild(description);

                    // Add language
                    const language = document.createElement('span');
                    language.textContent = repo.language;
                    card.appendChild(language);

                    // Add metrics
                    const metricsList = document.createElement('ul');

                    const stars = document.createElement('li');
                    stars.textContent = `Stars: ${repo.stargazers_count}`;
                    metricsList.appendChild(stars);

                    const forks = document.createElement('li');
                    forks.textContent = `Forks: ${repo.forks}`;
                    metricsList.appendChild(forks);
                    const size = document.createElement('li');
                    size.textContent = `Size: ${repo.size}`;
                    metricsList.appendChild(size);

                    card.appendChild(metricsList);

                    // Add "View on GitHub" button
                    const button = document.createElement('button');
                    button.textContent = "View on GitHub";
                    button.onclick = () => window.open(repo.svn_url, '_blank');
                    card.appendChild(button);

                    main.appendChild(card);




                }
            })
        })
}
// fetchrepos();

const underconstruction = () => {
    document.body.innerHTML = '<div class="underconstruction"><h1 class="underconsttitle">Under Construction</h1> <img src="https://media.giphy.com/media/Yj6d4OMmDV3bnYtOow/giphy.gif" alt="Under Construction" > </div>';
}
underconstruction();
