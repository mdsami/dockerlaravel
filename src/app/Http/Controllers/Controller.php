<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;

class Controller extends BaseController
{
    use AuthorizesRequests, ValidatesRequests;

    public function UploadImage($request, $name, $directory)
    {
        $doUpload = function ($image) use ($directory) {
            $name = pathinfo($image->getClientOriginalName(), PATHINFO_FILENAME);
            $extension = $image->getClientOriginalExtension();
            $imageName = $name . '_' . uniqid() . '.' . $extension;
            $path = $image->storeAs($directory, $imageName, 'public');
            $path = $directory.'/'.$imageName;
            return $path;
        };

        if (!empty($name) && $request->hasFile($name)) {
            $file = $request->file($name);

            if (is_array($file) && count($file)) {
                $imagesPath = [];

                foreach ($file as $key => $image) {
                    $imagesPath[] = $doUpload($image);
                }

                return $imagesPath;
            } else {
                return $doUpload($file);
            }
        }

        return false;
    }


}
