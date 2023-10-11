/** @type {import('tailwindcss').Config} */
export default {
	content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
	corePlugins: {
		// ...
	},

	theme: {
		fontFamily: {
			sans: ['Open Sans', 'sans-serif'],
			bold: ['Open Sans Bold', 'sans-serif'],
		},
		extend: {
			animation: {
				'police-car': 'movementRighToLeft',
				flash: 'flash 1s infinite',
				robber: 'secondmovementRighToLeft',
				spinSlightly: 'spinSlightly 4s infinite',
			},
			colors: {
				blacka: '#002400',
			},
			backgroundImage: {},
			keyframes: {
				movementRighToLeft: {
					'0%': {transform: 'translateX(0)'},
					'100%': {transform: 'translateX(100%)'},
				},
				secondmovementRighToLeft: {
					'0%': {transform: 'translateX(0)'},
					'100%': {transform: 'translateX(100%)'},
				},
				flash: {
					'0%': {opacity: '0'},
					'100%': {opacity: '1'},
				},
				spinSlightly: {
					'0%': {transform: 'rotate(0deg)'},
					'100%': {transform: 'rotate(30deg)'},
				},
			},
		},
	},
	plugins: [],
};
