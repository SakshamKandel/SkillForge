<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Certification" %>
<%
    Certification cert = (Certification) request.getAttribute("cert");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Certificate of Achievement - SkillForge</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;1,700&family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f8fafc; }
        .cert-font-serif { font-family: 'Playfair Display', serif; }
        
        @media print {
            .no-print { display: none; }
            body { background: white; margin: 0; padding: 0; }
            .cert-container { box-shadow: none; border: none; width: 100%; height: 100%; }
        }

        .cert-border {
            border: 20px solid #f1f5f9;
            outline: 2px solid #e2e8f0;
            outline-offset: -10px;
        }

        .gold-seal {
            background: radial-gradient(circle, #ffd700 0%, #d4af37 100%);
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.4);
        }
    </style>
</head>
<body class="p-4 sm:p-20 flex flex-col items-center">

    <div class="no-print mb-10 space-x-4">
        <button onclick="window.print()" class="bg-slate-900 text-white px-8 py-3 rounded-xl font-bold hover:bg-slate-800 transition-all flex items-center gap-2 inline-flex">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M6 9V2h12v7M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2m-12 0v4h10v-4M9 14h6"/></svg>
            Print Certificate
        </button>
        <a href="<%= ctx %>/student/courses" class="bg-white border text-slate-600 px-8 py-3 rounded-xl font-bold hover:bg-slate-50 transition-all inline-flex">
            Back to Dashboard
        </a>
    </div>

    <!-- ===== Certificate Page ===== -->
    <div class="cert-container bg-white w-full max-w-[1000px] aspect-[1.414/1] shadow-2xl relative overflow-hidden cert-border p-20 flex flex-col items-center justify-between text-center">
        
        <!-- Corner Decorations -->
        <div class="absolute top-0 left-0 w-40 h-40 border-t-8 border-l-8 border-emerald-500 opacity-20"></div>
        <div class="absolute bottom-0 right-0 w-40 h-40 border-b-8 border-r-8 border-emerald-500 opacity-20"></div>

        <div>
            <div class="flex items-center justify-center gap-3 mb-6">
                <div class="w-12 h-12 bg-slate-900 rounded-xl flex items-center justify-center">
                     <img src="<%= ctx %>/images/Logo.png" alt="Logo" class="w-7 h-7" />
                </div>
                <span class="text-2xl font-black text-slate-900 tracking-tighter uppercase">SkillForge</span>
            </div>
            <h3 class="text-xs font-black text-slate-400 uppercase tracking-[0.5em] mb-12">Verified Completion Certificate</h3>
        </div>

        <div>
            <p class="text-lg font-bold text-slate-500 mb-4">This hereby certifies that</p>
            <h1 class="text-6xl font-black text-slate-900 mb-8 tracking-tight"><%= cert.getStudentName() %></h1>
            <p class="text-lg font-bold text-slate-500 mb-12">has successfully completed the comprehensive curriculum for</p>
            <h2 class="text-4xl cert-font-serif italic text-emerald-600 mb-4"><%= cert.getCourseTitle() %></h2>
            <div class="w-32 h-1 bg-slate-100 mx-auto rounded-full"></div>
        </div>

        <div class="w-full flex justify-between items-end">
            <!-- Signature area -->
            <div class="text-left">
                <div class="cert-font-serif text-2xl text-slate-800 mb-1 italic">Ramesh Khatri</div>
                <div class="w-48 h-[1.5px] bg-slate-200 mb-2"></div>
                <p class="text-[0.6rem] font-black text-slate-400 uppercase tracking-widest">Lead Academic Director</p>
            </div>

            <!-- Seal -->
            <div class="gold-seal w-32 h-32 rounded-full border-4 border-white flex items-center justify-center relative scale-110">
                <div class="absolute inset-2 border-2 border-white/30 rounded-full border-dashed"></div>
                <svg class="w-12 h-12 text-white" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
            </div>

            <!-- Verification Info -->
            <div class="text-right">
                <p class="text-[0.6rem] font-black text-slate-400 uppercase tracking-widest mb-1">Issue Date: <%= cert.getIssuedAt() %></p>
                <p class="text-[0.6rem] font-black text-slate-800 uppercase tracking-widest">ID: <%= cert.getCertCode() %></p>
            </div>
        </div>

        <!-- Background Watermark -->
        <div class="absolute inset-0 flex items-center justify-center -z-10 opacity-[0.03] pointer-events-none">
            <span class="text-[20rem] font-black rotate-[-15deg] select-none">FORGE</span>
        </div>
    </div>

</body>
</html>
