<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="scroll-smooth">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ config('app.name', 'Splitra') }} - Autopilot Shared Expenses</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #0f172a; color: #f8fafc; }
        .glassp { background: rgba(30, 41, 59, 0.7); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.08); }
        .text-gradient { background: linear-gradient(135deg, #38bdf8, #818cf8, #c084fc); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .btn-primary { background: linear-gradient(to right, #3b82f6, #6366f1); color: white; padding: 0.75rem 2rem; border-radius: 9999px; font-weight: 500; transition: all 0.3s; box-shadow: 0 4px 14px 0 rgba(99, 102, 241, 0.39); }
        .btn-primary:hover { box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4); transform: translateY(-2px); }
        .feature-card { transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); }
        .feature-card:hover { transform: translateY(-5px); border-color: rgba(99, 102, 241, 0.5); box-shadow: 0 10px 30px -10px rgba(99, 102, 241, 0.3); }
    </style>
</head>
<body class="antialiased overflow-x-hidden selection:bg-indigo-500 selection:text-white">

    <!-- Navbar -->
    <nav class="fixed w-full z-50 glassp border-b border-slate-800/50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <div class="flex-shrink-0 flex items-center gap-3">
                    <img src="{{ asset('images/logo.png') }}" onerror="this.src='https://ui-avatars.com/api/?name=S&background=6366f1&color=fff&rounded=true'" alt="Logo" class="h-9 w-auto">
                    <span class="font-bold text-2xl tracking-tight text-white">{{ config('app.name', 'Splitra') }}</span>
                </div>
                <div class="hidden md:flex space-x-8 items-center font-medium">
                    <a href="#home" class="text-gray-300 hover:text-white transition-colors duration-200">Home</a>
                    <a href="#about" class="text-gray-300 hover:text-white transition-colors duration-200">About</a>
                    @if(!empty($settings['how_to_steps']))
                    <a href="#how-it-works" class="text-gray-300 hover:text-white transition-colors duration-200">Cara Kerja</a>
                    @endif
                    <a href="#pricing" class="text-gray-300 hover:text-white transition-colors duration-200">Pricing</a>
                    @if(!empty($settings['testimonials']))
                    <a href="#testimonials" class="text-gray-300 hover:text-white transition-colors duration-200">Testimoni</a>
                    @endif
                    <a href="#contact" class="text-gray-300 hover:text-white transition-colors duration-200">Contact Us</a>
                </div>
                
                <!-- Hamburger Button -->
                <div class="md:hidden flex items-center">
                    <button id="mobile-menu-btn" class="text-gray-300 hover:text-white focus:outline-none transition-colors duration-200" aria-label="Toggle menu">
                        <svg class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>

        <!-- Mobile Menu Dropdown -->
        <div id="mobile-menu" class="md:hidden hidden bg-[#0f172a]/95 backdrop-blur-xl border-t border-slate-800/80 absolute w-full left-0 top-full shadow-2xl transition-all">
            <div class="px-4 pt-4 pb-8 space-y-2">
                <a href="#home" class="mobile-nav-link block px-4 py-3 rounded-xl text-base font-semibold text-gray-300 hover:text-white hover:bg-indigo-500/20 transition-colors">Home</a>
                <a href="#about" class="mobile-nav-link block px-4 py-3 rounded-xl text-base font-semibold text-gray-300 hover:text-white hover:bg-indigo-500/20 transition-colors">About</a>
                @if(!empty($settings['how_to_steps']))
                <a href="#how-it-works" class="mobile-nav-link block px-4 py-3 rounded-xl text-base font-semibold text-gray-300 hover:text-white hover:bg-indigo-500/20 transition-colors">Cara Kerja</a>
                @endif
                <a href="#pricing" class="mobile-nav-link block px-4 py-3 rounded-xl text-base font-semibold text-gray-300 hover:text-white hover:bg-indigo-500/20 transition-colors">Pricing</a>
                @if(!empty($settings['testimonials']))
                <a href="#testimonials" class="mobile-nav-link block px-4 py-3 rounded-xl text-base font-semibold text-gray-300 hover:text-white hover:bg-indigo-500/20 transition-colors">Testimoni</a>
                @endif
                <a href="#contact" class="mobile-nav-link block px-4 py-3 rounded-xl text-base font-semibold text-gray-300 hover:text-white hover:bg-indigo-500/20 transition-colors">Contact Us</a>
                <a href="#download" class="mobile-nav-link block w-full text-center mt-4 px-4 py-3 rounded-xl font-bold bg-indigo-500 text-white shadow-lg hover:shadow-indigo-500/50 transition duration-300">Download App</a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="relative pt-32 pb-20 lg:pt-48 lg:pb-32 overflow-hidden min-h-screen flex items-center">
        <!-- Background Effects -->
        @if(!empty($settings['hero_image']))
        <div class="absolute inset-0 bg-cover bg-center opacity-40 mix-blend-overlay pointer-events-none" style="background-image: url('{{ Storage::url($settings['hero_image']) }}');"></div>
        <div class="absolute inset-0 bg-slate-900/60 z-0"></div>
        @else
        <div class="absolute inset-0 bg-[url('https://grainy-gradients.vercel.app/noise.svg')] opacity-20 mix-blend-overlay pointer-events-none"></div>
        @endif
        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-indigo-600/20 rounded-full blur-[120px] -z-10 pointer-events-none"></div>
        <div class="absolute top-0 right-0 w-[500px] h-[500px] bg-purple-600/20 rounded-full blur-[100px] -z-10 pointer-events-none"></div>
        
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 text-center">
            <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full glassp text-sm text-indigo-300 mb-8 motion-fade-in">
                <span class="relative flex h-2 w-2">
                  <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75"></span>
                  <span class="relative inline-flex rounded-full h-2 w-2 bg-indigo-500"></span>
                </span>
                AI-Powered Split Bill System v2.0
            </div>
            
            <h1 class="motion-slide-up text-5xl md:text-7xl font-extrabold tracking-tight mb-8 leading-[1.1]">
                <span class="block text-white drop-shadow-sm">{{ $settings['hero_title'] ?? 'The Smartest Way' }}</span>
                <span class="block text-gradient mt-2">{{ $settings['hero_subtitle'] ?? 'to Split Group Bills' }}</span>
            </h1>
            
            <p class="motion-fade-in text-xl md:text-2xl text-slate-400 max-w-3xl mx-auto mb-10 leading-relaxed font-light">
                Catat pengeluaran, bagi tagihan otomatis dengan OCR canggih, dan kelola keuangan sirkel Anda tanpa pusing. Semua tercatat rapi.
            </p>
            
            <div class="motion-fade-in-up flex flex-col sm:flex-row justify-center items-center gap-4">
                <a href="#pricing" class="btn-primary flex items-center gap-2 text-lg">
                    {{ $settings['hero_cta_text'] ?? 'Mulai Gratis Sekarang' }}
                    <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path></svg>
                </a>
                <a href="#about" class="px-8 py-3 rounded-full text-slate-300 font-medium hover:text-white hover:bg-slate-800/50 transition-colors duration-300">
                    Pelajari Lebih Lanjut
                </a>
            </div>
            
            <!-- Dashboard Preview Snippet -->
            <div class="mt-20 relative mx-auto max-w-5xl motion-scale-up">
                <div class="rounded-xl bg-slate-800/50 p-2 ring-1 ring-white/10 backdrop-blur-sm -m-2 lg:-m-4">
                    <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=2000&q=80" alt="App Dashboard Mockup" class="rounded-lg shadow-2xl opacity-80 mix-blend-luminosity hover:mix-blend-normal transition duration-500">
                    <div class="absolute inset-0 bg-gradient-to-t from-slate-900 via-transparent to-transparent z-10"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section id="about" class="py-24 bg-slate-900/50 border-y border-slate-800/50 relative">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-20 scroll-animate-up">
                <h2 class="text-sm font-bold tracking-widest text-indigo-500 uppercase mb-3">Keunggulan</h2>
                <h3 class="text-3xl md:text-5xl font-bold mb-6 text-white">{{ $settings['about_title'] ?? 'Kenapa Memilih Splitra?' }}</h3>
                <div class="w-24 h-1 bg-gradient-to-r from-blue-500 to-indigo-500 mx-auto rounded-full"></div>
                @if(!empty($settings['about_description']))
                <div class="mt-8 text-slate-400 text-lg max-w-3xl mx-auto leading-relaxed text-left prose prose-invert">
                    {!! $settings['about_description'] !!}
                </div>
                @endif
            </div>
            
            <div class="grid md:grid-cols-3 gap-8 mt-12">
                @if(!empty($settings['about_features']))
                @foreach($settings['about_features'] as $index => $feature)
                @php
                    $color = $feature['color'] ?? 'indigo';
                    $delay = $index * 100;
                @endphp
                <div class="glassp p-8 rounded-3xl feature-card scroll-animate-up" style="transition-delay: {{ $delay }}ms;">
                    <div class="w-14 h-14 rounded-2xl flex items-center justify-center mb-6 
                        {{ $color == 'indigo' ? 'bg-indigo-500/20 text-indigo-400' : '' }}
                        {{ $color == 'purple' ? 'bg-purple-500/20 text-purple-400' : '' }}
                        {{ $color == 'emerald' ? 'bg-emerald-500/20 text-emerald-400' : '' }}
                        {{ $color == 'blue' ? 'bg-blue-500/20 text-blue-400' : '' }}
                        {{ $color == 'rose' ? 'bg-rose-500/20 text-rose-400' : '' }}
                        {{ $color == 'amber' ? 'bg-amber-500/20 text-amber-400' : '' }}
                    ">
                        @if(!empty($feature['icon_svg']))
                            {!! $feature['icon_svg'] !!}
                        @else
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                        @endif
                    </div>
                    <h4 class="text-xl font-bold mb-3 text-white">{{ $feature['title'] ?? '' }}</h4>
                    <p class="text-slate-400 leading-relaxed">{{ $feature['description'] ?? '' }}</p>
                </div>
                @endforeach
                @else
                <!-- Feature 1 -->
                <div class="glassp p-8 rounded-3xl feature-card scroll-animate-up">
                    <div class="w-14 h-14 rounded-2xl bg-indigo-500/20 flex items-center justify-center mb-6 text-indigo-400">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                    </div>
                    <h4 class="text-xl font-bold mb-3 text-white">Smart OCR Scanner</h4>
                    <p class="text-slate-400 leading-relaxed">Pindai struk belanjaan secara instan. AI akan mengekstrak item harga dan pajak otomatis dengan akurasi tinggi.</p>
                </div>
                
                <!-- Feature 2 -->
                <div class="glassp p-8 rounded-3xl feature-card scroll-animate-up" style="transition-delay: 100ms;">
                    <div class="w-14 h-14 rounded-2xl bg-purple-500/20 flex items-center justify-center mb-6 text-purple-400">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                    </div>
                    <h4 class="text-xl font-bold mb-3 text-white">Share Grup Bill</h4>
                    <p class="text-slate-400 leading-relaxed">Bagikan tautan tagihan unik ke teman. Tak ada aplikasi? Tidak masalah, mereka bisa bayar dan upload bukti dari web publik.</p>
                </div>
                
                <!-- Feature 3 -->
                <div class="glassp p-8 rounded-3xl feature-card scroll-animate-up" style="transition-delay: 200ms;">
                    <div class="w-14 h-14 rounded-2xl bg-emerald-500/20 flex items-center justify-center mb-6 text-emerald-400">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path></svg>
                    </div>
                    <h4 class="text-xl font-bold mb-3 text-white">Analisa Keuangan AI</h4>
                    <p class="text-slate-400 leading-relaxed">Ringkasan pengeluaran bulanan. Identifikasi pola belanja terboros Anda dengan AI Financial Insight bawaan dari Splitra.</p>
                </div>
                @endif
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    @if(!empty($settings['how_to_steps']))
    <section id="how-it-works" class="py-24 bg-[#0B1120] relative border-b border-slate-800/50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16 scroll-animate-up">
                <h2 class="text-sm font-bold tracking-widest text-indigo-500 uppercase mb-3">Cara Kerja</h2>
                <h3 class="text-3xl md:text-5xl font-bold mb-6 text-white">Langkah Mudah Memulai</h3>
                <div class="w-24 h-1 bg-gradient-to-r from-blue-500 to-indigo-500 mx-auto rounded-full"></div>
            </div>

            <div class="relative">
                <!-- Vertical timeline line -->
                <div class="hidden md:block absolute left-1/2 -ml-px w-0.5 h-full bg-slate-800/80"></div>
                
                <div class="space-y-12">
                    @foreach($settings['how_to_steps'] as $index => $step)
                    <div class="relative flex flex-col md:flex-row items-center justify-between scroll-animate-up" style="transition-delay: {{ $index * 100 }}ms;">
                        @if($index % 2 == 0)
                        <!-- Kiri -->
                        <div class="md:w-5/12 text-right order-2 md:order-1 mt-6 md:mt-0 glassp p-6 rounded-2xl w-full">
                            <h4 class="text-xl font-bold text-white mb-2">{{ $step['title'] ?? '' }}</h4>
                            <p class="text-slate-400 leading-relaxed">{{ $step['description'] ?? '' }}</p>
                        </div>
                        <!-- Tengah Node -->
                        <div class="z-10 bg-indigo-500 w-10 h-10 shadow-[0_0_20px_rgba(99,102,241,0.5)] rounded-full flex items-center justify-center font-bold text-white border-4 border-[#0B1120] order-1 md:order-2">
                            {{ $index + 1 }}
                        </div>
                        <!-- Kanan Kosong -->
                        <div class="md:w-5/12 order-3"></div>
                        @else
                        <!-- Kiri Kosong -->
                        <div class="md:w-5/12 order-3 md:order-1 hidden md:block"></div>
                        <!-- Tengah Node -->
                        <div class="z-10 bg-purple-500 w-10 h-10 shadow-[0_0_20px_rgba(168,85,247,0.5)] rounded-full flex items-center justify-center font-bold text-white border-4 border-[#0B1120] order-1 md:order-2">
                            {{ $index + 1 }}
                        </div>
                        <!-- Kanan -->
                        <div class="md:w-5/12 text-left order-2 md:order-3 mt-6 md:mt-0 glassp p-6 rounded-2xl w-full">
                            <h4 class="text-xl font-bold text-white mb-2">{{ $step['title'] ?? '' }}</h4>
                            <p class="text-slate-400 leading-relaxed">{{ $step['description'] ?? '' }}</p>
                        </div>
                        @endif
                    </div>
                    @endforeach
                </div>
            </div>
        </div>
    </section>
    @endif

    <!-- Pricing Section -->
    <section id="pricing" class="py-24 relative overflow-hidden bg-slate-900 border-b border-slate-800/50">
        <div class="absolute top-0 right-1/4 w-[400px] h-[400px] bg-indigo-600/10 rounded-full blur-[100px] -z-10"></div>
        
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-12 scroll-animate-up">
                <h2 class="text-3xl md:text-5xl font-bold mb-6 text-white">Pilihan <span class="text-gradient">Paket Terbaik</span></h2>
                <p class="text-slate-400 text-lg max-w-2xl mx-auto">Kami menyediakan skema terpadu dari gratis hingga enterprise untuk gaya hidup sirkel Anda.</p>
            </div>

            <!-- Pricing Toggle Tabs -->
            <div class="flex justify-center mb-16 scroll-animate-up">
                <div class="glassp flex p-1 rounded-full relative z-20">
                    <button class="pricing-tab-btn active px-8 py-2.5 rounded-full text-sm font-semibold transition-all duration-300 bg-indigo-500 text-white shadow-lg" data-target="monthly">Bulanan</button>
                    <button class="pricing-tab-btn px-8 py-2.5 rounded-full text-sm font-semibold transition-all duration-300 text-slate-400 hover:text-white" data-target="yearly">Tahunan <span class="ml-2 text-[10px] bg-emerald-500/20 text-emerald-400 px-2 py-0.5 rounded-full">Hemat 20%</span></button>
                    <button class="pricing-tab-btn px-8 py-2.5 rounded-full text-sm font-semibold transition-all duration-300 text-slate-400 hover:text-white" data-target="lifetime">Lifetime</button>
                </div>
            </div>

            <!-- Tab Content Wrapper -->
            <div class="relative">
                
                <!-- Monthly Tab -->
                <div id="tab-monthly" class="pricing-content active grid md:grid-cols-2 lg:grid-cols-3 gap-8 items-stretch justify-center" style="display: grid;">
                    @foreach($plansMonthly ?? [] as $index => $plan)
                        @include('components.pricing-card', ['plan' => $plan, 'index' => $index])
                    @endforeach
                    @if(count($plansMonthly ?? []) === 0) <div class="col-span-full py-20 text-center text-slate-500">Belum ada data paket Bulanan.</div> @endif
                </div>

                <!-- Yearly Tab -->
                <div id="tab-yearly" class="pricing-content grid md:grid-cols-2 lg:grid-cols-3 gap-8 items-stretch justify-center" style="display: none;">
                    @foreach($plansYearly ?? [] as $index => $plan)
                        @include('components.pricing-card', ['plan' => $plan, 'index' => $index])
                    @endforeach
                    @if(count($plansYearly ?? []) === 0) <div class="col-span-full py-20 text-center text-slate-500">Belum ada data paket Tahunan.</div> @endif
                </div>

                <!-- Lifetime Tab -->
                <div id="tab-lifetime" class="pricing-content grid md:grid-cols-2 lg:grid-cols-3 gap-8 items-stretch justify-center" style="display: none;">
                    @foreach($plansLifetime ?? [] as $index => $plan)
                        @include('components.pricing-card', ['plan' => $plan, 'index' => $index])
                    @endforeach
                    @if(count($plansLifetime ?? []) === 0) <div class="col-span-full py-20 text-center text-slate-500">Belum ada data paket Lifetime.</div> @endif
                </div>

                <!-- Comparison Detail Link -->
                <div class="mt-20 text-center scroll-animate-up">
                    <a href="{{ route('comparison') }}" class="inline-flex items-center gap-2 px-6 py-3 rounded-2xl glassp text-indigo-400 hover:text-white hover:bg-indigo-500/20 transition-all border border-indigo-500/30 group">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path></svg>
                        Bandingkan semua fitur paket detail
                        <svg class="w-4 h-4 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                    </a>
                </div>
            </div>
            
        </div>
    </section>

    <!-- Testimonial Section -->
    @if(!empty($settings['testimonials']))
    <section id="testimonials" class="py-24 bg-slate-900/30 relative">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16 scroll-animate-up">
                <h2 class="text-sm font-bold tracking-widest text-indigo-500 uppercase mb-3">Testimoni</h2>
                <h3 class="text-3xl md:text-5xl font-bold mb-6 text-white">Apa Kata Mereka?</h3>
                <div class="w-24 h-1 bg-gradient-to-r from-blue-500 to-indigo-500 mx-auto rounded-full"></div>
            </div>

            <div class="columns-1 md:columns-2 lg:columns-3 gap-6 space-y-6">
                @foreach($settings['testimonials'] as $index => $testi)
                <div class="glassp p-8 rounded-3xl break-inside-avoid scroll-animate-up cursor-pointer hover:-translate-y-2 hover:border-indigo-500/50 transition duration-500 shadow-xl" style="transition-delay: {{ ($index % 3) * 100 }}ms;">
                    
                    <!-- Stars -->
                    <div class="flex text-amber-400 mb-6">
                        @for($i=0; $i<5; $i++)
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                        @endfor
                    </div>

                    <p class="text-slate-300 text-lg leading-relaxed italic mb-8">"{{ $testi['message'] ?? '' }}"</p>
                    
                    <div class="flex items-center gap-4 border-t border-slate-700/50 pt-6">
                        <div class="w-12 h-12 rounded-full bg-gradient-to-tr from-indigo-500 to-purple-500 flex items-center justify-center text-lg font-bold text-white shadow-inner uppercase">
                            {{ substr($testi['name'] ?? 'A', 0, 1) }}
                        </div>
                        <div>
                            <h5 class="text-white font-bold text-sm">{{ $testi['name'] ?? '' }}</h5>
                            <p class="text-slate-400 text-xs mt-1">{{ $testi['role'] ?? '' }}</p>
                        </div>
                    </div>
                </div>
                @endforeach
            </div>
        </div>
    </section>
    @endif

    <!-- Download App Section -->
    <section id="download" class="py-24 bg-gradient-to-b from-slate-900 to-[#0a0f21] relative border-t border-slate-800/50">
        <div class="absolute inset-0 bg-[url('https://grainy-gradients.vercel.app/noise.svg')] opacity-10 mix-blend-overlay pointer-events-none"></div>
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 text-center">
            
            <div class="inline-flex items-center justify-center p-4 rounded-full bg-indigo-500/10 mb-8 mx-auto scroll-animate-up">
                <svg class="w-12 h-12 text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"></path></svg>
            </div>
            
            <h2 class="text-4xl md:text-5xl font-extrabold mb-6 text-white scroll-animate-up">
                Satu Aplikasi Lakukan Semua
            </h2>
            <p class="text-xl text-slate-400 mb-10 leading-relaxed scroll-animate-up" style="transition-delay: 100ms;">
                Ambil alih kontrol keuangan grup Anda sekarang. Unduh aplikasi Splitra secara gratis untuk mencoba pengalaman berbagi tagihan paling mulus.
            </p>

            <div class="flex flex-col sm:flex-row justify-center items-center gap-4 scroll-animate-up" style="transition-delay: 200ms;">
                
                @if(!empty($settings['download_playstore']))
                <a href="{{ $settings['download_playstore'] }}" target="_blank" class="flex items-center gap-3 bg-white text-slate-900 px-8 py-4 rounded-2xl font-bold hover:-translate-y-1 hover:shadow-xl hover:shadow-white/20 transition-all w-full sm:w-auto justify-center">
                    <svg class="w-8 h-8" viewBox="0 0 512 512" fill="currentColor"><path d="M325.3 234.3L104.6 13l280.8 161.2-60.1 60.1zM47 0C34 6.8 25.3 19.2 25.3 35.3v441.3c0 16.1 8.7 28.5 21.7 35.3l256.6-256L47 0zm425.2 225.6l-58.9-34.1-65.7 64.5 65.7 64.5 60.1-34.1c18-14.3 18-46.5-1.2-60.8zM104.6 499l280.8-161.2-60.1-60.1L104.6 499z"></path></svg>
                    <div class="text-left">
                        <div class="text-[10px] font-semibold uppercase tracking-wider text-slate-500">Get IT ON</div>
                        <div class="text-lg leading-tight tracking-tight">Google Play</div>
                    </div>
                </a>
                @endif

                @if(!empty($settings['download_appstore']))
                <a href="{{ $settings['download_appstore'] }}" target="_blank" class="flex items-center gap-3 bg-indigo-600 text-white px-8 py-4 rounded-2xl font-bold hover:-translate-y-1 hover:bg-indigo-500 hover:shadow-xl hover:shadow-indigo-500/30 transition-all border border-indigo-400/30 w-full sm:w-auto justify-center">
                    <svg class="w-8 h-8" viewBox="0 0 384 512" fill="currentColor"><path d="M318.7 268.7c-.2-36.7 16.4-64.4 50-84.8-18.8-26.9-47.2-41.7-84.7-44.6-35.5-2.8-74.3 20.7-88.5 20.7-15 0-49.4-19.7-76.4-19.7C63.3 141.2 4 184.8 4 273.5q0 39.3 14.4 81.2c12.8 36.7 59 126.7 107.2 125.2 25.2-.6 43-17.9 75.8-17.9 31.8 0 48.3 17.9 76.4 17.9 48.6-.7 90.4-82.5 102.6-119.3-65.2-30.7-61.7-90-61.7-91.9zm-56.6-164.2c27.3-32.4 24.8-61.9 24-72.5-24.1 1.4-52 16.4-67.9 34.9-17.5 19.8-27.8 44.3-25.6 71.9 26.1 2 49.9-11.4 69.5-34.3z"></path></svg>
                    <div class="text-left">
                        <div class="text-[10px] font-medium text-indigo-200">Download on the</div>
                        <div class="text-lg leading-tight tracking-tight">App Store</div>
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

    <!-- Contact Section -->
    <section id="contact" class="py-24 bg-[#0a0f21] relative border-t border-slate-800/50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16 scroll-animate-up">
                <h2 class="text-sm font-bold tracking-widest text-indigo-500 uppercase mb-3">Hubungi Kami</h2>
                <h3 class="text-3xl md:text-5xl font-bold mb-6 text-white">Butuh Bantuan?</h3>
                <div class="w-24 h-1 bg-gradient-to-r from-blue-500 to-indigo-500 mx-auto rounded-full"></div>
            </div>

            <div class="grid md:grid-cols-2 gap-12 items-center">
                <div class="scroll-animate-up">
                    <p class="text-slate-400 text-lg mb-8">Tim support kami selalu siap membantu Anda menyelesaikan masalah atau menjawab pertanyaan seputar aplikasi Splitra.</p>
                    
                    <div class="space-y-6">
                        @if(!empty($settings['contact_email']))
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-full bg-indigo-500/20 flex items-center justify-center text-indigo-400">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                            </div>
                            <div>
                                <h4 class="text-white font-bold">Email</h4>
                                <a href="mailto:{{ $settings['contact_email'] }}" class="text-slate-400 hover:text-indigo-400">{{ $settings['contact_email'] }}</a>
                            </div>
                        </div>
                        @endif

                        @if(!empty($settings['contact_phone']))
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-full bg-indigo-500/20 flex items-center justify-center text-indigo-400">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                            </div>
                            <div>
                                <h4 class="text-white font-bold">Telepon / WhatsApp</h4>
                                <p class="text-slate-400">{{ $settings['contact_phone'] }}</p>
                            </div>
                        </div>
                        @endif

                        @if(!empty($settings['contact_address']))
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-full bg-indigo-500/20 flex items-center justify-center text-indigo-400 shrink-0">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            </div>
                            <div>
                                <h4 class="text-white font-bold">Alamat Kantor</h4>
                                <p class="text-slate-400 max-w-xs">{{ $settings['contact_address'] }}</p>
                            </div>
                        </div>
                        @endif
                    </div>
                </div>

                <div class="glassp p-8 rounded-3xl scroll-animate-up border-indigo-500/20 relative" style="transition-delay: 200ms;">
                    <div class="absolute -top-4 -right-4 w-24 h-24 bg-indigo-500/10 rounded-full blur-xl z-0"></div>
                    <form class="space-y-4 relative z-10" onsubmit="event.preventDefault(); alert('Pesan berhasil terkirim!');">
                        <div>
                            <label class="block text-sm font-medium text-slate-400 mb-1">Nama Lengkap</label>
                            <input type="text" class="w-full bg-slate-800/50 border border-slate-700 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition-colors" placeholder="Masukkan nama Anda">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-400 mb-1">Email</label>
                            <input type="email" class="w-full bg-slate-800/50 border border-slate-700 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition-colors" placeholder="Alamat email aktif">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-400 mb-1">Pesan</label>
                            <textarea rows="4" class="w-full bg-slate-800/50 border border-slate-700 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition-colors" placeholder="Sampaikan pertanyaan Anda..."></textarea>
                        </div>
                        <button type="submit" class="w-full btn-primary py-3 rounded-xl font-bold mt-2">Kirim Pesan</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="border-t border-slate-800/80 bg-[#0a0f21] py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row justify-between items-center gap-6">
            <div class="flex items-center gap-3">
                 <img src="{{ asset('images/logo.png') }}" onerror="this.src='https://ui-avatars.com/api/?name=S&background=6366f1&color=fff&rounded=true'" alt="Logo" class="h-8 w-auto grayscale opacity-70 hover:grayscale-0 hover:opacity-100 transition-all">
                 <span class="font-bold text-xl tracking-tight text-white opacity-80">{{ config('app.name', 'Splitra') }}</span>
            </div>
            <p class="text-slate-500 font-medium text-sm text-center md:text-left">
                {{ $settings['footer_text'] ?? '© 2026 Splitra Inc. All rights reserved.' }}
            </p>
            <div class="flex space-x-6">
                @if(!empty($settings['footer_twitter']))
                 <a href="{{ $settings['footer_twitter'] }}" class="text-slate-500 hover:text-indigo-400 transition-colors">
                     <span class="sr-only">Twitter</span>
                     <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84"></path></svg>
                 </a>
                @endif
                @if(!empty($settings['footer_instagram']))
                 <a href="{{ $settings['footer_instagram'] }}" class="text-slate-500 hover:text-indigo-400 transition-colors">
                     <span class="sr-only">Instagram</span>
                     <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path fill-rule="evenodd" d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z" clip-rule="evenodd"></path></svg>
                 </a>
                @endif
                @if(!empty($settings['footer_github']))
                 <a href="{{ $settings['footer_github'] }}" class="text-slate-500 hover:text-indigo-400 transition-colors">
                     <span class="sr-only">GitHub</span>
                     <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path fill-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z" clip-rule="evenodd"></path></svg>
                 </a>
                @endif
            </div>
        </div>
    </footer>

    <!-- Motion.dev Animation Scripts -->
    <script type="module">
        import { animate, inView, stagger } from "https://cdn.jsdelivr.net/npm/motion@11.11.13/+esm";

        // Hero initial animations
        animate(".motion-fade-in", { opacity: [0, 1] }, { duration: 1, delay: 0.1 });
        animate(".motion-slide-up", { y: [40, 0], opacity: [0, 1] }, { duration: 0.8, easing: "ease-out" });
        animate(".motion-fade-in-up", { y: [20, 0], opacity: [0, 1] }, { duration: 0.7, delay: 0.3, easing: "ease-out" });
        animate(".motion-scale-up", { scale: [0.95, 1], y: [30, 0], opacity: [0, 1] }, { duration: 1, delay: 0.5, easing: "ease-out" });

        // Scroll animations for sections and cards
        inView(".scroll-animate-up", ({ target }) => {
            animate(target, { y: [50, 0], opacity: [0, 1] }, { duration: 0.8, easing: "ease-out" });
        });
        
        // Dynamic active state for navbar
        const navbar = document.querySelector('nav');
        window.addEventListener('scroll', () => {
            if (window.scrollY > 20) {
                navbar.classList.add('shadow-lg', 'bg-slate-900/90');
                navbar.classList.remove('border-slate-800/50');
            } else {
                navbar.classList.remove('shadow-lg', 'bg-slate-900/90');
                navbar.classList.add('border-slate-800/50');
            }
        });

        // Mobile Menu Toggle
        document.addEventListener('DOMContentLoaded', () => {
            const mobileMenuBtn = document.getElementById('mobile-menu-btn');
            const mobileMenu = document.getElementById('mobile-menu');
            const mobileMenuLinks = document.querySelectorAll('.mobile-nav-link');

            if (mobileMenuBtn && mobileMenu) {
                mobileMenuBtn.addEventListener('click', () => {
                    mobileMenu.classList.toggle('hidden');
                    // Add subtle slide down animation with motion
                    if (!mobileMenu.classList.contains('hidden')) {
                        animate(mobileMenu, { opacity: [0, 1], y: [-10, 0] }, { duration: 0.3 });
                    }
                });
                
                // Tutup menu saat link diklik
                mobileMenuLinks.forEach(link => {
                    link.addEventListener('click', () => {
                        mobileMenu.classList.add('hidden');
                    });
                });
            }
        });

        // Pricing Tabs Switcher Logic
        document.addEventListener('DOMContentLoaded', () => {
            const tabs = document.querySelectorAll('.pricing-tab-btn');
            const contents = document.querySelectorAll('.pricing-content');

            tabs.forEach(tab => {
                tab.addEventListener('click', () => {
                    const target = tab.getAttribute('data-target');
                    
                    // Reset Active Tabs
                    tabs.forEach(t => {
                        t.classList.remove('active', 'bg-indigo-500', 'text-white', 'shadow-lg');
                        t.classList.add('text-slate-400');
                    });
                    
                    // Set Active Tab
                    tab.classList.remove('text-slate-400');
                    tab.classList.add('active', 'bg-indigo-500', 'text-white', 'shadow-lg');

                    // Reset Active Content
                    contents.forEach(content => {
                        content.classList.remove('active');
                        content.style.display = 'none';
                        content.style.opacity = '';
                        content.style.transform = '';
                    });

                    // Set Active Content
                    const activeContent = document.getElementById('tab-' + target);
                    if(activeContent) {
                        activeContent.classList.add('active');
                        activeContent.style.display = 'grid';
                        // re-trigger animation manually or just let CSS opacity transition handle it
                        animate(activeContent, { opacity: [0, 1], y: [20, 0] }, { duration: 0.5 });
                    }
                });
            });
        });
    </script>
</body>
</html>
