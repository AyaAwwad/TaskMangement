<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class TaskController extends ResourceController
{
    protected $format = 'json'; // عشان دايماً يرجع رد JSON

    // كتابة مفتاح الـ API الذي تتوقعه
    private $validApiKey = '123456'; // استبدل هذا بالمفتاح الفعلي

    // دالة للتحقق من الـ API Key
    private function validateApiKey()
    {
        $apiKey = $this->request->getHeader('API-Key');
        if ($apiKey && $apiKey->getValue() === $this->validApiKey) {
            return true;
        } else {
            return false;
        }
    }

    // عرض كل التاسكات
    public function index()
    {
        // إعدادات CORS
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, API-Key');

        if (!$this->validateApiKey()) {
            return $this->respond(['message' => 'Forbidden: Invalid API Key'], 403);
        }

        // البيانات الوهمية
        $tasks = [
            ['id' => 1, 'title' => 'Task 1', 'completed' => false],
            ['id' => 2, 'title' => 'Task 2', 'completed' => true],
        ];

        return $this->respond($tasks);
    }

    // إنشاء تاسك جديد
    public function create()
    {
        // إعدادات CORS
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, API-Key');

        if (!$this->validateApiKey()) {
            return $this->respond(['message' => 'Forbidden: Invalid API Key'], 403);
        }

        // الحصول على البيانات من الـ POST request
        $data = $this->request->getJSON();

        return $this->respondCreated([
            'message' => 'Task created successfully',
            'task' => $data,
        ]);
    }
}
