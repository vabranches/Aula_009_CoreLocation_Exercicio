
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: Outlets
    @IBOutlet weak var mapa: MKMapView!
    
    //MARK: Propriedades
    var gerenciadorGPS = CLLocationManager()
    var coordenadasOrigem = CLLocationCoordinate2DMake(-23.550186, -46.633386)
    let coordenadasDestino = CLLocationCoordinate2DMake(-23.566200, -46.652563)
    let zoom = MKCoordinateSpanMake(0.02, 0.02)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorGPS.desiredAccuracy = kCLLocationAccuracyBest
        
        //Determinando as coordenadas de inicialização
        let regiao = MKCoordinateRegionMake(coordenadasOrigem, zoom)
        mapa.setRegion(regiao, animated: true)
        mapa.setCenter(coordenadasOrigem, animated: true)
        
        //Criando um Pino para a localização
        adicionarPino(coordenadas: coordenadasDestino, titulo: "Quaddro Treinamentos")
        //adicionarPino(coordenadas: coordenadasOrigem, titulo: "Você está aqui!")

        

    }
    
    //MARK: Actions
    @IBAction func mudar(_ sender: UISegmentedControl) {
        //Verifica se há autorizacao para acessar o GPS
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
            
            gerenciadorGPS.requestWhenInUseAuthorization()
        } else {
            mapa.showsUserLocation = true
            gerenciadorGPS.delegate = self
            gerenciadorGPS.startUpdatingLocation()
            
            if sender.selectedSegmentIndex == 0{
                mudarLocalizacao(coordenadas: coordenadasOrigem)
            } else {
                mudarLocalizacao(coordenadas: coordenadasDestino)
            }
            
        }
    }
    
    //MARK: Metodos de CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacao = locations.last
        let zoom = MKCoordinateSpanMake(0.01, 0.01)
        let regiao = MKCoordinateRegionMake(localizacao!.coordinate, zoom)
        mapa.setRegion(regiao, animated: true)
        
    }
    
    //MARK: Métodos Personalizados
    func mudarLocalizacao(coordenadas : CLLocationCoordinate2D){
        let regiao = MKCoordinateRegionMake(coordenadas, zoom)
        mapa.setRegion(regiao, animated: true)
        mapa.setCenter(coordenadas, animated: true)
    }
    
    func adicionarPino(coordenadas : CLLocationCoordinate2D, titulo : String){
        let pino = MKPointAnnotation()
        pino.title = titulo
        pino.coordinate = coordenadas
        mapa.addAnnotation(pino)
    }
    



}

