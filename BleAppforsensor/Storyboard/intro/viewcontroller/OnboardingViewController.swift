import UIKit

class OnboardingViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet{
            pageControl.currentPage = currentPage
            if currentPage == slides.count-1 {
                nextBtn.setTitle("Get Started", for: .normal)
            }
            else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        slides = [OnboardingSlide(title: "Monitor Your Pet's Health",description: "Measure Your Pet's Preathing Rate and Alert for Abnormal Breathing Pattern", image: UIImage(imageLiteralResourceName: "Intro_1")),
                  OnboardingSlide(title: "Save The Record in Cloud", description: "Save Your Pet's Health Data in FireBase. You can View Your Pet Health Record at Anytime on App", image: UIImage(imageLiteralResourceName: "Intro_2")),
                  OnboardingSlide(title: "Monitor Your Pet's Health", description: "Measure Your Pet's Preathing Rate and Alert for Abnormal Breathing Pattern", image:UIImage(imageLiteralResourceName: "Intro_3"))]
        pageControl.numberOfPages = slides.count
    }
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if currentPage == slides.count-1{
            let controller = storyboard?.instantiateViewController(withIdentifier: "Home") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller,animated: true,completion: nil)
        }
        else{
            
            collectionView.isPagingEnabled = false
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
            
        }
        
    }
}
   
extension OnboardingViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slide: slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
        
    }
}
