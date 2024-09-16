# Storyboarding Training

## XCode Project

- **IDE:** `XCode 14.3.1 for iOS 16.4`
- **Language:** `Swift 5`
- **Interface:** `Storyboard`

## Dependencies

### Package Dependencies

- KeychainSwift `20.0.0`
- Reachability `master`
- IQKeyboardManagerSwift `6.5.12`

## Feature

- MVVM
- Remember Me
- API Integration
- Logger
- Coordinator Design Pattern for navigation
- Image Caching

## Server Configuration

	~ % cat ~/.zprofile 
	eval "$(/opt/homebrew/bin/brew shellenv)"
	
	~ % cat ~/.zshrc
	export NVM_DIR=~/.nvm
	source $(brew --prefix nvm)/nvm.sh
	
	~ % source ~/.zshrc
	
	~ % nvm install --lts
	~ % node --version 
	v18.17.0
	
	~ % nvm install lts/gallium
	Now using node v16.20.1 (npm v8.19.4)
	
	~ % nvm alias default v16.20.1
	default -> v16.20.1
	
	~ % nvm ls
	       v14.21.3
	->     v16.20.1
	       v18.17.0
       
	~ % npm --version
	8.19.4
	~ % which npm
	/Users/william.rena/.nvm/versions/node/v16.20.1/bin/npm
	
	~ % mkdir ~/.localhost
	~ % ls ~/.localhost                    
	digital-products-cms
	
## Running the Server API (Localhost)

	digital-products-cms % nvm use v16.20.1
	Now using node v16.20.1 (npm v8.19.4)

	~ % nvm ls
		       v14.21.3
		->     v16.20.1
		       v18.17.0
	       
	~ % cd ~/.localhost
	.localhost % ls
	digital-products-cms
	.localhost % cd digital-products-cms 
	digital-products-cms %

	digital-products-cms % yarn nx serve strapi
	yarn run v1.22.19
	...
	http://localhost:8080/
	
## Credentials

* Username: wilyamx@gmail.com
* password: Fed@00059