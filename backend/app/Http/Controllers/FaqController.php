namespace App\Http\Controllers;
 
use Illuminate\Http\Request;
use App\Models\Faq;

class FaqController extends Controller
{
    public function index()
    {
        $faqs = Faq::where('is_published', true)
            ->orderBy('sort_order', 'asc')
            ->get();
            
        return response()->json([
            'message' => 'FAQ berhasil diambil',
            'data' => $faqs
        ]);
    }
}
