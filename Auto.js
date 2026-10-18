(function () {
    // منع تكرار إنشاء الزر إذا كان موجوداً بالفعل
    if (document.getElementById('tiktok-autotap-btn')) return;

    // إنشاء الزر العائم
    const btn = document.createElement('button');
    btn.id = 'tiktok-autotap-btn';
    btn.innerText = '⚡ تكبيس';
    
    // تنسيق الزر العائم
    Object.assign(btn.style, {
        position: 'fixed',
        bottom: '100px',
        right: '20px',
        zIndex: '999999',
        padding: '12px 24px',
        backgroundColor: '#FE2C55',
        color: '#FFFFFF',
        border: 'none',
        borderRadius: '30px',
        fontSize: '16px',
        fontWeight: 'bold',
        boxShadow: '0 4px 15px rgba(0, 0, 0, 0.3)',
        cursor: 'pointer',
        userSelect: 'none',
        transition: 'all 0.2s ease'
    });

    document.body.appendChild(btn);

    let isRunning = false;
    let tapInterval = null;

    // وظيفة المحاكاة عند الضغط
    btn.onclick = function (e) {
        e.stopPropagation(); // منع انتقال الضغطة للخلفية

        if (!isRunning) {
            isRunning = true;
            btn.innerText = '⏹️ إيقاف';
            btn.style.backgroundColor = '#25F4EE';
            btn.style.color = '#000000';

            // التكبيس التلقائي في المنتصف كل 40 مللي ثانية
            tapInterval = setInterval(() => {
                const centerX = window.innerWidth / 2;
                const centerY = window.innerHeight / 2;
                const targetEl = document.elementFromPoint(centerX, centerY);

                if (targetEl) {
                    ['pointerdown', 'touchstart', 'mousedown', 'pointerup', 'touchend', 'mouseup', 'click'].forEach(eventType => {
                        const evt = new MouseEvent(eventType, {
                            view: window,
                            bubbles: true,
                            cancelable: true,
                            clientX: centerX,
                            clientY: centerY
                        });
                        targetEl.dispatchEvent(evt);
                    });
                }
            }, 40);
        } else {
            isRunning = false;
            clearInterval(tapInterval);
            btn.innerText = '⚡ تكبيس';
            btn.style.backgroundColor = '#FE2C55';
            btn.style.color = '#FFFFFF';
        }
    };
})();
