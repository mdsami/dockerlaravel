<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\TestRequest;
use App\Models\Test;

class TestController extends Controller
{
    public function index()
    {
        $uploads = Test::all();
        return view('test',compact('uploads'));
    }
    public function store(TestRequest $request)
    {
       
        $photo = $request->hasFile('image')
                    ? $this->UploadImage($request, 'image', 'uploads/test')
                    : '';
        try {
            $test = Test::create([
                'title' => $request->title,
                'image' => $photo,
            ]);
        } catch (\Exception $e) {
            return redirect()->route('test.index')->with('message', 'Test Not Created');
        }
        return redirect()->route('test.index')->with('message', 'Test Create SuccessFully');
    }
}
