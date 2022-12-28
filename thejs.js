const fetchrepos = () => {
	fetch('https://api.github.com/users/Krugou/repos')
		.then(response => response.json())
		.then(data => {
			// export data to another function

			generateCards(data);

		})
}
const generateCards = (data) => {
	const main = document.querySelector('main');
	const header = document.querySelector('header');
	const prelink = 'https://krugou.github.io/'
	data.forEach(repo => {
		// if name is github github-slideshow then skip
		if (repo.name === 'github-slideshow' || repo.name === 'krugou.github.io') {
			return;
		}
		// make card
		const card = document.createElement('div');
		card.classList.add('card');
		if (repo.has_pages) {
			const link = document.createElement('a');
			link.setAttribute('href', prelink + repo.name);
			link.textContent = 'website for repo: ' + repo.name;
			card.appendChild(link);
		}
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
		button.textContent = "github repo link";
		button.onclick = () => window.open(repo.svn_url, '_blank');
		card.appendChild(button);

		main.appendChild(card);





	})
}
// fetchrepos();

const underconstruction = () => {
	document.body.innerHTML = '<div class="underconstruction"><h1 class="underconsttitle">Under Construction</h1>' +
		'<img class="underconstrimage" src="https://media.giphy.com/media/Yj6d4OMmDV3bnYtOow/giphy.gif" alt = "Under Construction" >' +
		' </div> ';
	const underConstruction = document.querySelector('.underconstruction');
	underConstruction.style.display = 'flex';
	underConstruction.style.alignContent = 'center';
	underConstruction.style.justifyContent = 'center';
	underConstruction.style.flexDirection = 'column';
	underConstruction.style.margin = '1rem';
	underConstruction.style.padding = '1rem';

	const underConstTitle = document.querySelector('.underconsttitle');
	underConstTitle.style.textAlign = 'center';
	underConstTitle.style.transform = 'scaleX(1.5)';
	underConstTitle.style.animation = 'transforms 5s infinite forwards';
	underConstTitle.style.margin = '1rem';
	underConstTitle.style.padding = '1rem';

	const underConstrImage = document.querySelector('.underconstrimage');
	underConstrImage.style.display = 'flex';
	underConstrImage.style.justifyContent = 'center';
	underConstrImage.style.flexDirection = 'column';
	underConstrImage.style.alignContent = 'center';
	underConstrImage.style.width = '80vw';
	underConstrImage.style.margin = '1rem';
	underConstrImage.style.padding = '1rem';
}
underconstruction();
