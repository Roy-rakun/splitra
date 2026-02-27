<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="scroll-smooth">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Perbandingan Paket - {{ config('app.name', 'Splitra') }}</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #0f172a; color: #f8fafc; }
        .glassp { background: rgba(30, 41, 59, 0.7); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.08); }
        .text-gradient { background: linear-gradient(135deg, #38bdf8, #818cf8, #c084fc); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .btn-primary { background: linear-gradient(to right, #3b82f6, #6366f1); color: white; padding: 0.75rem 2rem; border-radius: 9999px; font-weight: 500; transition: all 0.3s; box-shadow: 0 4px 14px 0 rgba(99, 102, 241, 0.39); }
        .feature-row:hover { background-color: rgba(255, 255, 255, 0.02); }
        /* Custom Scrollbar */
        .custom-scrollbar::-webkit-scrollbar { width: 8px; height: 8px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: #0f172a; border-radius: 10px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #334155; border-radius: 10px; transition: all 0.3s; }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: #4f46e5; }
        /* For Firefox */
        .custom-scrollbar { scrollbar-width: thin; scrollbar-color: #334155 #0f172a; }
    </style>
</head>
<body class="antialiased overflow-x-hidden selection:bg-indigo-500 selection:text-white">

    <!-- Navbar -->
    <nav class="fixed w-full z-50 glassp border-b border-slate-800/50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <a href="/" class="flex-shrink-0 flex items-center gap-3">
                    <img src="{{ asset('images/logo.png') }}" onerror="this.src='https://ui-avatars.com/api/?name=S&background=6366f1&color=fff&rounded=true'" alt="Logo" class="h-9 w-auto">
                    <span class="font-bold text-2xl tracking-tight text-white">{{ config('app.name', 'Splitra') }}</span>
                </a>
                <div class="hidden md:flex space-x-10 items-center font-medium">
                    <a href="/" class="text-gray-300 hover:text-white transition-colors duration-200">Kembali ke Beranda</a>
                    <a href="/#pricing" class="btn-primary text-sm">Pilih Paket</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="relative pt-32 pb-16 overflow-hidden bg-slate-900">
        <div class="absolute top-0 left-1/2 -translate-x-1/2 w-full h-[500px] bg-indigo-600/10 blur-[120px] -z-10"></div>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center relative z-10">
            <h1 class="text-4xl md:text-6xl font-extrabold mb-6 text-white drop-shadow-sm">Comparison</h1>
            <p class="text-slate-400 text-lg md:text-xl max-w-2xl mx-auto">Perbandingan detail fitur untuk membantu Anda memilih rencana yang paling sesuai dengan kebutuhan finansial grup Anda.</p>
        </div>
    </section>

    <!-- Comparison Table Section -->
    <section class="pb-24 bg-slate-900 border-b border-slate-800/50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="rounded-3xl border border-slate-800/80 shadow-2xl glassp overflow-auto custom-scrollbar" style="max-height: calc(100vh - 100px);">
                <table class="w-full text-left border-collapse min-w-[1000px] relative">
                    <thead>
                        <tr class="bg-indigo-950/20">
                            <th class="sticky top-0 z-30 p-6 text-indigo-400 font-bold uppercase tracking-wider text-xs border-b border-slate-700/50 bg-slate-900">Fitur</th>
                            <th class="sticky top-0 z-30 p-6 text-center border-b border-slate-700/50 bg-slate-900">
                                <span class="block text-white font-bold">Free</span>
                                <span class="text-[10px] text-slate-500 font-normal">IDR 0</span>
                            </th>
                            <th class="sticky top-0 z-30 p-6 text-center border-b border-slate-700/50 bg-slate-900">
                                <span class="block text-indigo-400 font-bold">Premium Personal</span>
                                <span class="text-[10px] text-slate-500 font-normal text-indigo-300/50 italic">Best for individuals</span>
                            </th>
                            <th class="sticky top-0 z-30 p-6 text-center border-b border-slate-700/50 bg-slate-900">
                                <span class="block text-white font-bold">Lifetime</span>
                                <span class="text-[10px] text-slate-500 font-normal italic">Sekali bayar</span>
                            </th>
                            <th class="sticky top-0 z-30 p-6 text-center border-b border-slate-700/50 bg-slate-900">
                                <span class="block text-purple-400 font-bold">Premium Group</span>
                                <span class="text-[10px] text-slate-500 font-normal text-purple-300/50 italic">Best for circle</span>
                            </th>
                            <th class="sticky top-0 z-30 p-6 text-center border-b border-slate-700/50 bg-slate-900">
                                <span class="block text-white font-bold">B2B</span>
                                <span class="text-[10px] text-slate-500 font-normal italic">Bisnis & Event</span>
                            </th>
                            <th class="sticky top-0 z-30 p-6 text-center border-b border-slate-700/50 bg-slate-900">
                                <span class="block text-emerald-400 font-bold">White Label</span>
                                <span class="text-[10px] text-slate-500 font-normal text-emerald-300/50 italic">Full Branding</span>
                            </th>
                        </tr>
                    </thead>
                    <tbody class="text-sm font-medium">
                        <!-- CATEGORY: AKSES & DASAR -->
                        <tr class="bg-indigo-500/5">
                            <td colspan="7" class="px-6 py-4 text-xs font-bold text-indigo-400 uppercase tracking-widest flex items-center gap-2">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"></path></svg>
                                AKSES & DASAR
                            </td>
                        </tr>
                        @php
                            $checkmark = '<div class="flex justify-center"><div class="w-6 h-6 rounded-md bg-emerald-500/20 text-emerald-400 flex items-center justify-center"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg></div></div>';
                            $crossmark = '<div class="flex justify-center"><div class="w-6 h-6 rounded-md bg-rose-500/20 text-rose-400 flex items-center justify-center"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12"></path></svg></div></div>';
                            $dashmark = '<div class="flex justify-center text-slate-600">—</div>';
                        @endphp
                        
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Wajib Login</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $dashmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $dashmark !!}</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Multi-device</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $dashmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Cloud Sync</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $dashmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                        </tr>

                        <!-- CATEGORY: SCAN & EDIT STRUK -->
                        <tr class="bg-indigo-500/5">
                            <td colspan="7" class="px-6 py-4 text-xs font-bold text-indigo-400 uppercase tracking-widest flex items-center gap-2">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M12 9c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3zm10.67 3.33c0 .96-.28 1.83-.75 2.58l.08.09 1.5 1.5-1.42 1.42-1.5-1.5-.09-.08c-.75.47-1.62.75-2.58.75-2.67 0-4.83-2.16-4.83-4.83h2c0 1.56 1.27 2.83 2.83 2.83.67 0 1.28-.24 1.76-.64l-1.09-1.09c-.21.06-.43.09-.67.09-1.1 0-2-.9-2-2s.9-2 2-2c.24 0 .46.03.67.09l1.09-1.09c-.48-.4-1.09-.64-1.76-.64-1.56 0-2.83 1.27-2.83 2.83h-2c0-2.67 2.16-4.83 4.83-4.83.96 0 1.83.28 2.58.75l.09-.08 1.5-1.5 1.42 1.42-1.5 1.5-.08.09c.47.75.75 1.62.75 2.58zm-19.34 0c0-.96.28-1.83.75-2.58l-.08-.09-1.5-1.5 1.42-1.42 1.5 1.5.09.08c.75-.47 1.62-.75 2.58-.75 2.67 0 4.83 2.16 4.83 4.83h-2c0-1.56-1.27-2.83-2.83-2.83-.67 0-1.28.24-1.76.64l1.09 1.09c.21-.06.43-.09.67-.09 1.1 0 2 .9 2 2s-.9 2-2 2c-.24 0-.46-.03-.67-.09l-1.09 1.09c.48.4 1.09.64 1.76.64 1.56 0 2.83-1.27 2.83-2.83h2c0 2.67-2.16 4.83-4.83 4.83-.96 0-1.83-.28-2.58-.75l-.09.08-1.5 1.5-1.42-1.42 1.5-1.5.08-.09c-.47-.75-.75-1.62-.75-2.58z"></path></svg>
                                SCAN & EDIT STRUK
                            </td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Scan struk</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-300 font-semibold italic">5x / bln</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold uppercase tracking-tight">Unlimited</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400">20x / bln</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold">Unlimited</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400">Unlimited</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-300">Unlimited AI Quota</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">OCR + AI parsing</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400">Basic</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-300 font-bold">Advanced</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-500">Basic</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-300">Advanced</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400">Custom Scope</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">AI correction & suggest</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-rose-500/50 italic">via Add-on</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $dashmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400">Fixed SLA</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Edit item (Detail)</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $dashmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                        </tr>

                        <!-- CATEGORY: SPLIT BILL & SETTLEMENT -->
                        <tr class="bg-indigo-500/5">
                            <td colspan="7" class="px-6 py-4 text-xs font-bold text-indigo-400 uppercase tracking-widest flex items-center gap-2">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M8.433 7.418c.155-.103.346-.196.567-.267v1.698a2.305 2.305 0 01-.567-.267C8.07 8.34 8 8.114 8 8c0-.114.07-.34.433-.582zM11 12.849v-1.698c.22.071.412.164.567.267.364.243.433.468.433.582 0 .114-.07.34-.433.582a2.305 2.305 0 01-.567.267z"></path><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-13a1 1 0 10-2 0v.092a4.535 4.535 0 00-1.676.662C6.602 6.234 6 7.009 6 8c0 .99.602 1.765 1.324 2.246.48.32 1.054.545 1.676.662v1.941c-.391-.127-.68-.317-.843-.504a1 1 0 10-1.514 1.315C7.259 14.237 8.047 14.754 9 14.958V15a1 1 0 102 0v-.092c.506-.079 1.035-.226 1.456-.508.813-.544 1.544-1.41 1.544-2.4 0-.99-.602-1.765-1.324-2.246A4.535 4.535 0 0011 9.092V7.151c.391.127.68.317.843.504a1 1 0 101.514-1.315C12.741 5.763 11.953 5.246 11 5.042V5z" clip-rule="evenodd"></path></svg>
                                SPLIT BILL & SETTLEMENT
                            </td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Split (Rata / Item)</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-400 font-bold">QR Based</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Participant (Add/Exclude)</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-500">No install</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Mark Paid & Proof Upload</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Partial Payment</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                        </tr>

                        <!-- CATEGORY: REMINDER & NAGIH -->
                        <tr class="bg-indigo-500/5">
                            <td colspan="7" class="px-6 py-4 text-xs font-bold text-indigo-400 uppercase tracking-widest flex items-center gap-2">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 004 14h12a1 1 0 00.707-1.707L16 11.586V8a6 6 0 00-6-6zM10 18a3 3 0 01-3-3h6a3 3 0 01-3 3z"></path></svg>
                                REMINDER & NAGIH
                            </td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Reminder Manual</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400">Copy text</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Reminder Otomatis (WA)</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold">Wajar</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400">Wajar</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $dashmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-400">Bulk</td>
                        </tr>

                        <!-- CATEGORY: MONEY TRACKER & INSIGHT -->
                        <tr class="bg-indigo-500/5">
                            <td colspan="7" class="px-6 py-4 text-xs font-bold text-indigo-400 uppercase tracking-widest flex items-center gap-2">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M3 3a1 1 0 000 2v10a2 2 0 002 2h10a2 2 0 002-2V5a1 1 0 10-2 0v10H5V3a1 1 0 00-1-1zm6 4a1 1 0 10-2 0v5a1 1 0 002 0V7zm3 4a1 1 0 10-2 0v1a1 1 0 002 0v-1zm3-2a1 1 0 10-2 0v3a1 1 0 002 0V9z" clip-rule="evenodd"></path></svg>
                                MONEY TRACKER & INSIGHT
                            </td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Expense Auto-Simpan</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400 italic">Basic</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold uppercase tracking-tight">Full Tracker</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-500">Manual Only</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold uppercase tracking-tight">Full Tracker</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">History Transaksi</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400 italic">14 hari<br><span class="text-[10px] text-rose-400/70">(Lama Read-only)</span></td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold tracking-tight">unlimited</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold tracking-tight">unlimited</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-300">Terpusat</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-500">Anonymized</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-400">Custom Log</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Chart & Breakdown</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-500">Basic</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-300 font-semibold italic">Breakdown & Insight</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400">Simple Chart</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-purple-400 font-bold">Group Analytics</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400">Peak Hour</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400">Full Branding</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Category & Merchant Insight</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Budget & Alert (AI Coach)</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-300 font-semibold italic">Monthly & Budget</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold italic">Predictive AI</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $dashmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-300 font-bold uppercase">Dedicated</td>
                        </tr>

                        <!-- CATEGORY: GROUP & KOLABORASI -->
                        <tr class="bg-indigo-500/5">
                            <td colspan="7" class="px-6 py-4 text-xs font-bold text-indigo-400 uppercase tracking-widest flex items-center gap-2">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-3a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v3h-3zM4.75 12.094A5.973 5.973 0 004 15v3H1v-3a3 3 0 013.75-2.906z"></path></svg>
                                GROUP & KOLABORASI
                            </td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Jumlah Group</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-500">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $dashmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400">1 Group Aktif</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold tracking-tight">unlimited</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-400">Multiple Outlet</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold tracking-tight">unlimited</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Member per Group</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-500 italic">No Group</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $dashmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400">Max 5</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-300 font-bold">15 Member</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold tracking-tight">unlimited</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold tracking-tight">unlimited</td>
                        </tr>

                        <!-- CATEGORY: BUSINESS & ENTERPRISE -->
                        <tr class="bg-indigo-500/5">
                            <td colspan="7" class="px-6 py-4 text-xs font-bold text-indigo-400 uppercase tracking-widest flex items-center gap-2">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M4 4a2 2 0 012-2h8a2 2 0 012 2v12a1 1 0 110 2h-3a1 1 0 01-1-1v-2a1 1 0 00-1-1H9a1 1 0 00-1 1v2a1 1 0 01-1 1H4a1 1 0 110-2V4zm3 1h2v2H7V5zm2 4H7v2h2V9zm2-4h2v2h-2V5zm2 4h-2v2h2V9z" clip-rule="evenodd"></path></svg>
                                BUSINESS & ENTERPRISE
                            </td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">QR / Web Bill View</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-400 font-bold">No Install</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400">Custom Domain</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Merchant Dashboard</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-300">Outlet & Stats</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold tracking-tight">unlimited</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Full White Label</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-500 font-medium italic">Partial Branding</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold">Dedicated App</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">API & Webhooks</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-300 font-bold tracking-tight">Dedicated</td>
                        </tr>
                        <!-- CATEGORY: BATASAN & SECURITY -->
                        <tr class="bg-rose-500/5">
                            <td colspan="7" class="px-6 py-4 text-xs font-bold text-rose-400 uppercase tracking-widest flex items-center gap-2">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"></path></svg>
                                BATASAN (LIMITATIONS)
                            </td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Settlement Tracking</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-rose-400">{!! $crossmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50">{!! $checkmark !!}</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-500">No Custody</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400">Custom Flow</td>
                        </tr>
                        <tr class="feature-row">
                            <td class="p-6 text-slate-300 border-b border-slate-800/50">Automation Fair Usage</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-rose-500 font-bold uppercase">Restricted</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-300 italic">Fair Usage</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-400 font-bold">Standard</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-indigo-300 italic">Fair Usage</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-slate-500 italic">Anonymized</td>
                            <td class="p-6 border-b border-slate-800/50 text-center text-emerald-400 font-bold tracking-tight italic">unlimited</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- Download App Section (Reused) -->
    <section id="download" class="py-24 bg-gradient-to-b from-slate-900 to-[#0a0f21] relative border-t border-slate-800/50">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 text-center">
            <h2 class="text-4xl md:text-5xl font-extrabold mb-6 text-white uppercase tracking-tight">SIAP UNTUK LEBIH MUDAH?</h2>
            <p class="text-xl text-slate-400 mb-10 leading-relaxed">Unduh aplikasi Splitra sekarang untuk mencoba pengalaman perbandingan fitur ini secara nyata di genggaman Anda.</p>
            <div class="flex flex-col sm:flex-row justify-center items-center gap-4">
                @if(!empty($settings['download_playstore']))
                <a href="{{ $settings['download_playstore'] }}" target="_blank" class="flex items-center gap-3 bg-white text-slate-900 px-8 py-4 rounded-2xl font-bold hover:-translate-y-1 transition-all w-full sm:w-auto justify-center">
                    <svg class="w-8 h-8" viewBox="0 0 512 512" fill="currentColor"><path d="M325.3 234.3L104.6 13l280.8 161.2-60.1 60.1zM47 0C34 6.8 25.3 19.2 25.3 35.3v441.3c0 16.1 8.7 28.5 21.7 35.3l256.6-256L47 0zm425.2 225.6l-58.9-34.1-65.7 64.5 65.7 64.5 60.1-34.1c18-14.3 18-46.5-1.2-60.8zM104.6 499l280.8-161.2-60.1-60.1L104.6 499z"></path></svg>
                    <div class="text-left">
                        <div class="text-[10px] uppercase font-bold text-slate-500">GET IT ON</div>
                        <div class="text-lg leading-tight">Google Play</div>
                    </div>
                </a>
                @endif
                @if(!empty($settings['download_appstore']))
                <a href="{{ $settings['download_appstore'] }}" target="_blank" class="flex items-center gap-3 bg-indigo-600 text-white px-8 py-4 rounded-2xl font-bold hover:-translate-y-1 hover:shadow-xl transition-all w-full sm:w-auto justify-center">
                    <svg class="w-8 h-8" viewBox="0 0 384 512" fill="currentColor"><path d="M318.7 268.7c-.2-36.7 16.4-64.4 50-84.8-18.8-26.9-47.2-41.7-84.7-44.6-35.5-2.8-74.3 20.7-88.5 20.7-15 0-49.4-19.7-76.4-19.7C63.3 141.2 4 184.8 4 273.5q0 39.3 14.4 81.2c12.8 36.7 59 126.7 107.2 125.2 25.2-.6 43-17.9 75.8-17.9 31.8 0 48.3 17.9 76.4 17.9 48.6-.7 90.4-82.5 102.6-119.3-65.2-30.7-61.7-90-61.7-91.9zm-56.6-164.2c27.3-32.4 24.8-61.9 24-72.5-24.1 1.4-52 16.4-67.9 34.9-17.5 19.8-27.8 44.3-25.6 71.9 26.1 2 49.9-11.4 69.5-34.3z"></path></svg>
                    <div class="text-left">
                        <div class="text-[10px] font-medium text-indigo-200 uppercase">Download on the</div>
                        <div class="text-lg leading-tight">App Store</div>
                    </div>
                </a>
                @endif

                @if(!empty($settings['download_direct']))
                <a href="{{ $settings['download_direct'] }}" class="flex items-center gap-2 text-slate-400 hover:text-white transition-colors w-full sm:w-auto justify-center mt-4 sm:mt-0 font-medium">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
                    Download APK (.apk)
                </a>
                @endif

            </div>
        </div>
    </section>

    <!-- Footer (Reused) -->
    <footer class="border-t border-slate-800/80 bg-[#0a0f21] py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row justify-between items-center gap-6">
            <div class="flex items-center gap-3">
                 <img src="{{ asset('images/logo.png') }}" onerror="this.src='https://ui-avatars.com/api/?name=S&background=6366f1&color=fff&rounded=true'" alt="Logo" class="h-8 w-auto grayscale opacity-50">
                 <span class="font-bold text-xl tracking-tight text-white opacity-60">{{ config('app.name', 'Splitra') }}</span>
            </div>
            <p class="text-slate-500 font-medium text-sm">
                {{ $settings['footer_text'] ?? '© 2026 Splitra Inc. All rights reserved.' }}
            </p>
        </div>
    </footer>

</body>
</html>
