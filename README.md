
<a name="readme-top"></a>



<!-- PROJECT LOGO -->
<br />
<div align="center">
    <img src="https://user-images.githubusercontent.com/52799665/228613935-3e22aa58-bb38-4feb-8592-11f67e3715c4.png" alt="Logo" width="80" height="80">

  <h3 align="center">Price History</h3>


  <p align="center">
    This app will show you price history for E-commerce products in Morocco. The app is designed to be run for free on AWS free tier. This repo will allow you to deploy the infrastructure to AWS using terraform, it also icludes tests scripts to validate your deployement and a frontend you can run locally. 
    <br />
    <a href="https://www.tariqmassaoudi.com/jumiaapp/">Live Demo</a>
    ·
     <a href="https://www.tariqmassaoudi.com/jumia-price-comparator/">Article (Old Implementation)</a>
    .
    <a href="https://github.com/tariqmassaoudi/price_history_terraform/issues">Request Feature</a>
  </p>

</div>
<div><p align="center">
<img  src="https://user-images.githubusercontent.com/52799665/228614596-5ebedbd3-b1a1-403c-b494-378ee25e4f20.png" width="600" height="400">
</p>
    </div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#terraform-deployement-instructions">Terraform Deployement Instructions</a></li>
     <li><a href="#testing">Testing</a></li>
     <li><a href="#running-the-front-end">Running The Front End</a></li>
           <li><a href="#features">Features</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>







### Terraform Deployement Instructions
1. Clone this repo
```
git clone https://github.com/tariqmassaoudi/price_history_terraform
```
2. In the root directory create a file named: "credentials" with the content below : <br/>
```
[default]
aws_access_key_id = YOUR AWS ACCESS KEY
aws_secret_access_key = YOUR AWS SECRET KEY
```
3. Install Terraform CLI
4. Run these commands in the root directory
```
terraform init
terraform apply
```
5.Wait for the ressources to be deployed, it takes around 15 minutes. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->

## Testing
To validate your terraform deployement execute this:
```
cd tests
pip install -r requirements.txt
python execute_all_tests.py
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Running The Front End
```
cd frontend
npm i 
gatsby develop

```



## Features

* Tracks more than 200K products and updates price history for each one of them.
* Recommends top products that have dropped in price recently.
* One command deployement & Infrastructure as code with Terraform.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Tariq Massaoudi - [@linkedin](https://www.linkedin.com/in/tariqmassaoudi/) - tariq.massaoudi@gmail.com

Personal Website: [Tariq Massaoudi](https://tariqmassaoudi.com)

<p align="right">(<a href="#readme-top">back to top</a>)</p>




<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/tariqmassaoudi/two-subs/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/tariqmassaoudi/two-subs/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/packagist/stars/tariqmassaoudi/two-subs
[stars-url]: https://github.com/tariqmassaoudi/two-subs
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/tariqmassaoudi/two-subs/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/tariqmassaoudi/two-subs/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/tariqmassaoudi/
[product-screenshot]: images/screenshot.png

