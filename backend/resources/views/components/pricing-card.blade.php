<div class="glassp rounded-3xl p-8 relative flex flex-col hover:border-indigo-500/50 transition duration-500 scroll-animate-up {{ $plan->name === 'Premium' ? 'border-indigo-500/80 scale-[1.03] z-10 shadow-[0_0_40px_-10px_rgba(99,102,241,0.5)] bg-slate-800/80' : '' }}" style="transition-delay: {{ $index * 100 }}ms;">
    @if($plan->name === 'Premium')
    <div class="absolute -top-4 left-1/2 -translate-x-1/2 bg-gradient-to-r from-blue-500 to-indigo-500 text-white text-[11px] font-bold px-4 py-1.5 rounded-full uppercase tracking-widest shadow-lg">Most Popular</div>
    @endif
    
    <h3 class="text-2xl font-bold mb-2 text-white">{{ $plan->name }}</h3>
    <div class="flex items-baseline gap-1 mb-6">
        <span class="text-4xl lg:text-5xl font-extrabold text-white">Rp {{ number_format($plan->price, 0, ',', '.') }}</span>
        <span class="text-slate-400 font-medium">/{{ $plan->billing_cycle }}</span>
    </div>
    
    <div class="h-px w-full bg-slate-700/50 mb-6"></div>
    
    <div class="space-y-4 mb-10 text-slate-300 font-medium flex-grow plan-details-content">
        @if($plan->details)
            <style>
                .plan-details-content ul {
                    list-style: none;
                    padding: 0;
                    display: flex;
                    flex-direction: column;
                    gap: 1rem;
                }
                .plan-details-content li {
                    position: relative;
                    padding-left: 2.25rem;
                    line-height: 1.5;
                    margin-bottom: 0.75rem;
                    color: #cbd5e1; /* slate-300 */
                }
                .plan-details-content li:last-child {
                    margin-bottom: 0;
                }
                .plan-details-content li::before {
                    content: "";
                    position: absolute;
                    left: 0;
                    top: 0.125rem;
                    width: 1.25rem;
                    height: 1.25rem;
                    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke-width='3' stroke='%23818cf8'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' d='M5 13l4 4L19 7' /%3E%3C/svg%3E");
                    background-repeat: no-repeat;
                    background-size: contain;
                }
            </style>
            {!! $plan->details !!}
        @else
            <div class="flex gap-3 items-start">
                <svg class="w-6 h-6 text-indigo-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path></svg>
                <span>{{ $plan->scan_limit ?? 0 }} AI Receipt Scans /mo</span>
            </div>
        @endif
    </div>
    <a href="#download" class="w-full text-center py-3 rounded-full font-bold {{ $plan->name == 'Premium' ? 'bg-indigo-500 text-white shadow-lg hover:shadow-indigo-500/50' : 'bg-slate-800 text-white hover:bg-slate-700' }} transition duration-300">
            Pilih Paket Ini
        </a>
</div>
