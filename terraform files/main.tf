provider "google" {
  credentials = file("account.json")
  project     = "mythical-pod-269719"
  region      = "us-central1"
}




resource "google_compute_instance" "default" {
  name         = "github"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }


  metadata_startup_script = "sudo apt update; sudo apt install git; sudo ufw allow OpenSSH; sudo ufw allow http; sudo ufw allow https; sudo ufw enable"

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}


resource "google_compute_instance" "apache-test" {
  name         = "apache-test"
  machine_type = "f1-micro"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }


  metadata_startup_script = "sudo apt update; sudo apt install tasksel; sudo tasksel install lamp-server; sudo ufw allow OpenSSH; sudo ufw allow http; sudo ufw allow https; sudo ufw enable"


  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}



resource "google_compute_instance" "apache-prod" {
  name         = "apache-prod"
  machine_type = "f1-micro"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  metadata_startup_script = "sudo apt update; sudo apt install tasksel; sudo tasksel install lamp-server; sudo ufw allow OpenSSH; sudo ufw allow http; sudo ufw allow https; sudo ufw enable"


  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}


resource "google_compute_instance" "jenkins-test" {
  name         = "jenkins-test"
  machine_type = "f1-micro"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }
  metadata_startup_script = "sudo apt update; sudo apt install openjdk-8-jre; wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -; sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'; sudo apt install jenkins; sudo apt update; sudo systemctl start jenkins; sudo ufw allow 8080; sudo ufw allow OpenSSH; sudo ufw enable"


  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}





// Security Group
resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

resource "google_compute_network" "default" {
  name = "test-network"
}
