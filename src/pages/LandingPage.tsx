import { useState, useEffect, useRef, ReactNode } from 'react';
import { motion } from 'framer-motion';
import {
  GraduationCap, BookOpen, Users, Award, BarChart3, Star, CheckCircle2, ArrowRight, Play,
  Sparkles, Radio, Menu, X, ChevronDown, Calculator, Languages as LanguagesIcon,
  Cpu, Brain, Globe2, Briefcase, Code2, FlaskConical, ClipboardCheck, Gamepad2, Smartphone,
  UserCog, LineChart, PenLine, Trophy, School, FileCheck2, Bot, Mail, MapPin,
  Share2, AtSign, Link2, Camera, PlayCircle, BookMarked, Moon, Scale, Heart, Sunrise, MessageCircle,
} from 'lucide-react';

/* ──────────────────────────────────────────────────
   STATIC MARKETING CONTENT (illustrative — no backend)
────────────────────────────────────────────────── */
const TRUSTED_STATS = [
  { label: 'Active Students',  value: 12500, suffix: '+' },
  { label: 'Expert Teachers',  value: 340,   suffix: '+' },
  { label: 'Courses',          value: 620,   suffix: '+' },
  { label: 'Lessons',          value: 9800,  suffix: '+' },
  { label: 'Partner Schools',  value: 85,    suffix: '+' },
  { label: 'Certificates Issued', value: 7400, suffix: '+' },
];

const CATEGORIES = [
  { label: 'Quran',        icon: <BookMarked size={22}/> },
  { label: 'Tafseer',      icon: <BookOpen size={22}/> },
  { label: 'Aqeedah',      icon: <Moon size={22}/> },
  { label: 'Seerah',       icon: <Users size={22}/> },
  { label: 'Fiqh',         icon: <Scale size={22}/> },
  { label: 'Akhlaq',       icon: <Heart size={22}/> },
  { label: 'Daily Iman',   icon: <Sunrise size={22}/> },
  { label: 'Duas & Dhikr', icon: <MessageCircle size={22}/> },
];

// Real scholars & tafseer works sourced from the course's own reference list
// (Contant Vedio lactures.pdf) — no fabricated ratings/stats attached to
// scholarly work, per the project's content-governance rule.
const FEATURED_SCHOLARS = [
  { name: 'Mufti Muhammad Shafi Usmani', work: 'Ma’ariful Quran',   note: 'Comprehensive Urdu tafseer',        icon: <BookMarked size={20}/> },
  { name: 'Mufti Taqi Usmani',           work: 'Asan Tarjuma Quran',     note: 'Accessible Quran translation',      icon: <BookOpen size={20}/> },
  { name: 'Dr. Israr Ahmed',             work: 'Bayan-ul-Quran',         note: 'Thematic Quranic exposition',       icon: <Sparkles size={20}/> },
  { name: 'Maulana Abul Ala Maududi',    work: 'Tafheem-ul-Quran',       note: 'Contextual, contemporary tafseer',  icon: <Brain size={20}/> },
  { name: 'Maulana Aasif Qasmi Nanotwi', work: 'Baseerat-ul-Quran',      note: 'Translation & tafseer app',         icon: <Smartphone size={20}/> },
  { name: 'Ustad Shujauddin Shaikh',     work: 'Qurani Dars',            note: 'Live Quranic lessons',              icon: <GraduationCap size={20}/> },
];

const FEATURES = [
  { icon: <Bot size={22}/>,           title: 'AI Learning Assistant', desc: 'Personalized hints, practice sets, and study plans powered by AI.' },
  { icon: <Play size={22}/>,          title: 'Interactive Lessons',   desc: 'Engaging video-first lessons with quizzes woven right in.' },
  { icon: <Gamepad2 size={22}/>,      title: 'Gamification',          desc: 'Badges, streaks, and leaderboards that make learning stick.' },
  { icon: <Radio size={22}/>,         title: 'Live Classes',          desc: 'Real-time sessions with recordings for anytime catch-up.' },
  { icon: <ClipboardCheck size={22}/>,title: 'Assignments',           desc: 'Structured assignments with clear deadlines and feedback.' },
  { icon: <FileCheck2 size={22}/>,    title: 'Assessments',           desc: 'Auto-graded exams and question banks aligned to every course.' },
  { icon: <BarChart3 size={22}/>,     title: 'Analytics',             desc: 'Deep progress dashboards for students, teachers, and admins.' },
  { icon: <Award size={22}/>,         title: 'Certificates',          desc: 'Verified certificates the moment a course is completed.' },
  { icon: <Smartphone size={22}/>,    title: 'Mobile Learning',       desc: 'A fully responsive experience on any phone or tablet.' },
  { icon: <Users size={22}/>,         title: 'Parent Dashboard',      desc: 'Parents stay in the loop on attendance, grades, and progress.' },
  { icon: <UserCog size={22}/>,       title: 'Teacher Dashboard',     desc: 'Everything educators need to plan, teach, and grade in one place.' },
];

const PROCESS_STEPS = [
  { label: 'Register',    icon: <Users size={18}/> },
  { label: 'Choose Course',icon: <BookOpen size={18}/> },
  { label: 'Learn',        icon: <GraduationCap size={18}/> },
  { label: 'Practice',     icon: <ClipboardCheck size={18}/> },
  { label: 'Assessment',   icon: <FileCheck2 size={18}/> },
  { label: 'Certificate',  icon: <Award size={18}/> },
];

const TESTIMONIALS = [
  { name: 'Sample Student',    role: 'University Student',       text: 'The daily reflection questions helped me actually connect the ayah to my own life, not just read it.' },
  { name: 'Sample Instructor', role: 'Course Instructor',     text: 'Having the assignment, quiz, and scholar lectures all attached to the same ayah keeps the whole class focused.' },
  { name: 'Sample Parent', role: 'Parent',                text: 'I like that every lesson names its scholar and source — nothing feels made up or unsourced.' },
];

const ACHIEVEMENTS = [
  { icon: <Trophy size={22}/>,    label: '4.9/5 Average Rating' },
  { icon: <Award size={22}/>,     label: '7,400+ Certificates Issued' },
  { icon: <School size={22}/>,    label: '85+ Partner Schools' },
  { icon: <Globe2 size={22}/>,    label: 'Learners in 20+ Regions' },
];

const LATEST_COURSES = [
  { title: 'Data Structures Essentials', subject: 'Programming', icon: <Code2 size={20}/> },
  { title: 'Cell Biology Deep Dive',      subject: 'Science',     icon: <FlaskConical size={20}/> },
  { title: 'Public Speaking Skills',      subject: 'English',     icon: <PenLine size={20}/> },
  { title: 'Statistics for Beginners',    subject: 'Mathematics', icon: <Calculator size={20}/> },
  { title: 'Intro to Neural Networks',    subject: 'AI',          icon: <Brain size={20}/> },
];

const NEWS = [
  { title: 'Chapter 1 (Surah An-Nisa 4:136) now live with full scholar resources', date: 'Aug 2026', icon: <BookMarked size={20}/> },
  { title: 'Daily and weekly Iman-building routines added to every chapter',    date: 'Aug 2026', icon: <Sunrise size={20}/> },
  { title: 'More chapters and tafseer sources being added regularly',        date: 'Ongoing', icon: <Sparkles size={20}/> },
];

const FAQS = [
  { q: 'Is Iman Ki Shama suitable for all grade levels?',    a: 'Yes — Iman Ki Shama supports courses for primary, secondary, and vocational learners, with content organized by subject and level.' },
  { q: 'Are certificates verifiable?',                  a: 'Every certificate carries a unique certificate ID that can be verified from your dashboard once a course is completed.' },
  { q: 'Can parents track their child\'s progress?',    a: 'Yes, parents get their own dashboard view with attendance, grades, and course progress.' },
  { q: 'Does Iman Ki Shama work on mobile devices?',           a: 'Yes, Iman Ki Shama is fully responsive and works smoothly on phones, tablets, laptops, and desktops.' },
];

/* ──────────────────────────────────────────────────
   ANIMATED COUNTER
────────────────────────────────────────────────── */
function AnimatedCounter({ value, suffix = '' }: { value: number; suffix?: string }) {
  const ref = useRef<HTMLSpanElement>(null);
  const [display, setDisplay] = useState(0);
  const started = useRef(false);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const obs = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting && !started.current) {
          started.current = true;
          const duration = 1400;
          const start = performance.now();
          const tick = (now: number) => {
            const progress = Math.min(1, (now - start) / duration);
            const eased = 1 - Math.pow(1 - progress, 3);
            setDisplay(Math.round(eased * value));
            if (progress < 1) requestAnimationFrame(tick);
          };
          requestAnimationFrame(tick);
        }
      });
    }, { threshold: 0.4 });
    obs.observe(el);
    return () => obs.disconnect();
  }, [value]);

  return <span ref={ref}>{display.toLocaleString()}{suffix}</span>;
}

/* ──────────────────────────────────────────────────
   SMALL SECTION HELPERS
────────────────────────────────────────────────── */
function Eyebrow({ children }: { children: ReactNode }) {
  return (
    <span className="text-xs font-bold uppercase tracking-widest text-primary-700 bg-primary-50 px-3 py-1.5 rounded-full ring-1 ring-primary-100">
      {children}
    </span>
  );
}

export default function LandingPage({ onGetStarted }: { onGetStarted: () => void }) {
  const [openFaq, setOpenFaq] = useState<number | null>(0);
  const [mobileNavOpen, setMobileNavOpen] = useState(false);
  const [newsletterEmail, setNewsletterEmail] = useState('');
  const [subscribed, setSubscribed] = useState(false);

  const NAV_LINKS = [
    { href: '#features',   label: 'Features' },
    { href: '#courses',    label: 'Courses' },
    { href: '#categories', label: 'Categories' },
    { href: '#process',    label: 'How it Works' },
    { href: '#faq',        label: 'FAQ' },
  ];

  const handleSubscribe = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newsletterEmail.trim()) return;
    setSubscribed(true);
    setNewsletterEmail('');
  };

  return (
    <div className="min-h-screen bg-white font-sans">

      {/* ── Nav ── */}
      <nav className="fixed top-0 inset-x-0 z-50 border-b border-slate-100"
           style={{ background: 'rgba(255,255,255,0.85)', backdropFilter: 'blur(20px)' }}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
          <div className="flex items-center gap-2.5">
            <div className="bg-white rounded-xl px-1.5 py-1 shadow-sm ring-1 ring-slate-100 shrink-0">
              <img src="/assets/imaan-ki-shama-logo.png" alt="Iman Ki Shama" className="h-7 w-auto object-contain" />
            </div>
          </div>
          <div className="hidden md:flex items-center gap-6 text-sm font-medium text-slate-600">
            {NAV_LINKS.map((l) => (
              <a key={l.href} href={l.href} className="hover:text-brand-700 transition-colors">{l.label}</a>
            ))}
          </div>
          <div className="hidden sm:flex items-center gap-3">
            <button onClick={onGetStarted} className="text-sm font-semibold text-slate-700 hover:text-brand-700 transition-colors">Login</button>
            <button onClick={onGetStarted}
              className="px-4 py-2 rounded-xl text-sm font-semibold text-white transition-all hover:opacity-90 active:scale-95"
              style={{ background: 'linear-gradient(135deg,#007AFF,#0052AD)', boxShadow: '0 4px 14px rgba(0,82,173,0.35)' }}>
              Get Started
            </button>
          </div>
          <button
            className="md:hidden p-2 rounded-lg text-slate-700 hover:bg-slate-100 transition-colors"
            aria-label={mobileNavOpen ? 'Close menu' : 'Open menu'}
            onClick={() => setMobileNavOpen((v) => !v)}
          >
            {mobileNavOpen ? <X size={20} /> : <Menu size={20} />}
          </button>
        </div>

        {mobileNavOpen && (
          <div className="md:hidden border-t border-slate-100 bg-white animate-fade-down">
            <div className="px-4 sm:px-6 py-4 flex flex-col gap-1">
              {NAV_LINKS.map((l) => (
                <a key={l.href} href={l.href} onClick={() => setMobileNavOpen(false)}
                   className="px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-700 hover:bg-slate-50 hover:text-brand-700 transition-colors">
                  {l.label}
                </a>
              ))}
              <div className="flex flex-col gap-2 mt-3 pt-3 border-t border-slate-100">
                <button onClick={onGetStarted} className="px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-700 hover:bg-slate-50 transition-colors text-left">
                  Login
                </button>
                <button onClick={onGetStarted}
                  className="px-4 py-2.5 rounded-xl text-sm font-semibold text-white transition-all hover:opacity-90 active:scale-95"
                  style={{ background: 'linear-gradient(135deg,#007AFF,#0052AD)', boxShadow: '0 4px 14px rgba(0,82,173,0.35)' }}>
                  Get Started
                </button>
              </div>
            </div>
          </div>
        )}
      </nav>

      {/* ── Hero ── */}
      <section className="relative pt-32 pb-24 overflow-hidden"
               style={{ background: 'linear-gradient(135deg,#00182F 0%,#003466 55%,#0052AD 100%)' }}>
        <div className="absolute top-16 left-1/5 w-72 h-72 rounded-full opacity-20 animate-float" style={{ background: 'radial-gradient(circle,#007AFF,transparent 70%)' }} />
        <div className="absolute bottom-10 right-1/5 w-64 h-64 rounded-full opacity-15" style={{ background: 'radial-gradient(circle,#4A97FF,transparent 70%)', animation: 'float 8s ease-in-out infinite reverse' }} />
        <div className="absolute top-1/3 right-10 w-40 h-40 rounded-full opacity-10" style={{ background: 'radial-gradient(circle,#93C5FD,transparent 70%)', animation: 'float 10s ease-in-out infinite' }} />

        {/* Floating education icon chips */}
        <div className="hidden lg:block absolute top-40 left-12 p-3 rounded-2xl bg-white/10 border border-white/15 backdrop-blur-sm animate-float" style={{ animationDelay: '0.4s' }}>
          <BookOpen size={20} className="text-primary-300" />
        </div>
        <div className="hidden lg:block absolute bottom-32 left-24 p-3 rounded-2xl bg-white/10 border border-white/15 backdrop-blur-sm animate-float" style={{ animationDelay: '1.6s' }}>
          <GraduationCap size={20} className="text-primary-300" />
        </div>
        <div className="hidden lg:block absolute top-52 right-16 p-3 rounded-2xl bg-white/10 border border-white/15 backdrop-blur-sm animate-float" style={{ animationDelay: '2.4s' }}>
          <Sparkles size={20} className="text-primary-300" />
        </div>

        <motion.div
          initial={{ opacity: 0, y: 24 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
          className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="flex justify-center mb-6">
            <div className="bg-white rounded-2xl px-3 py-2 shadow-lg">
              <img src="/assets/imaan-ki-shama-logo.png" alt="Iman Ki Shama" className="h-10 sm:h-12 w-auto object-contain" />
            </div>
          </div>
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-xs font-semibold mb-6"
               style={{ background: 'rgba(0,122,255,0.15)', border: '1px solid rgba(0,122,255,0.35)', color: '#4A97FF' }}>
            <Sparkles size={13} />
            AI-Powered Learning Management System
          </div>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black text-white mb-6 leading-tight tracking-tight">
            Learning made<br />
            <span style={{ background: 'linear-gradient(90deg,#4A97FF,#007AFF)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
              brilliantly simple.
            </span>
          </h1>
          <p className="text-lg sm:text-xl text-white/75 mb-10 max-w-2xl mx-auto leading-relaxed">
            Iman Ki Shama brings courses, live classes, assignments, analytics, and verified certificates together in one beautifully designed platform.
          </p>
          <div className="flex flex-wrap gap-4 justify-center">
            <button onClick={onGetStarted}
              className="px-7 py-3.5 rounded-2xl text-sm font-bold text-white flex items-center justify-center gap-2 transition-all hover:scale-105 active:scale-95"
              style={{ background: 'linear-gradient(135deg,#007AFF,#0052AD)', boxShadow: '0 8px 32px rgba(0,82,173,0.5)' }}>
              Get Started <ArrowRight size={16}/>
            </button>
            <a href="#courses"
              className="px-7 py-3.5 rounded-2xl text-sm font-bold flex items-center justify-center gap-2 transition-all hover:scale-105"
              style={{ background: 'rgba(255,255,255,0.1)', border: '1px solid rgba(255,255,255,0.2)', color: 'white', backdropFilter: 'blur(10px)' }}>
              <Play size={15} className="fill-white"/> Explore Courses
            </a>
            <button onClick={onGetStarted}
              className="px-7 py-3.5 rounded-2xl text-sm font-bold flex items-center justify-center gap-2 transition-all hover:scale-105"
              style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.15)', color: 'white' }}>
              Login
            </button>
            <button onClick={onGetStarted}
              className="px-7 py-3.5 rounded-2xl text-sm font-bold flex items-center justify-center gap-2 transition-all hover:scale-105"
              style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.15)', color: 'white' }}>
              <GraduationCap size={15}/> Student Portal
            </button>
          </div>
          <p className="mt-5 text-white/50 text-sm">No credit card required · Free demo accounts available</p>

          {/* Hero dashboard preview mock */}
          <div className="mt-16 relative max-w-4xl mx-auto">
            <div className="rounded-3xl overflow-hidden"
                 style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.12)', boxShadow: '0 40px 120px rgba(0,0,0,0.5)' }}>
              <div className="bg-black/20 px-4 py-3 flex items-center gap-2 border-b border-white/10">
                <div className="flex gap-1.5">
                  <div className="w-3 h-3 rounded-full bg-white/20" />
                  <div className="w-3 h-3 rounded-full bg-white/20" />
                  <div className="w-3 h-3 rounded-full bg-white/20" />
                </div>
                <div className="flex-1 flex justify-center">
                  <div className="px-4 py-1 rounded-lg text-xs text-white/50" style={{ background: 'rgba(255,255,255,0.05)' }}>
                    Iman Ki Shama Dashboard
                  </div>
                </div>
              </div>
              <div className="p-6 grid grid-cols-2 sm:grid-cols-4 gap-4">
                {TRUSTED_STATS.slice(0, 4).map(s => (
                  <div key={s.label} className="text-center py-4 rounded-2xl" style={{ background: 'rgba(255,255,255,0.05)' }}>
                    <p className="text-2xl font-black text-white"><AnimatedCounter value={s.value} suffix={s.suffix} /></p>
                    <p className="text-xs text-white/50 mt-1">{s.label}</p>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </motion.div>
      </section>

      {/* ── Trusted By ── */}
      <section className="py-14 bg-[#fbf8f4] border-b border-slate-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <p className="text-center text-xs font-bold uppercase tracking-widest text-slate-400 mb-8">Trusted by learners and schools worldwide</p>
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-8 text-center">
            {TRUSTED_STATS.map(s => (
              <div key={s.label}>
                <p className="text-2xl sm:text-3xl font-black text-brand-700"><AnimatedCounter value={s.value} suffix={s.suffix} /></p>
                <p className="text-slate-500 text-xs mt-1">{s.label}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Ayah of the Day ── */}
      <section className="py-20 relative overflow-hidden" style={{ background: 'linear-gradient(135deg,#00182F 0%,#003466 55%,#0052AD 100%)' }}>
        <div className="absolute inset-0 opacity-20" style={{ backgroundImage: 'radial-gradient(1.5px 1.5px at 15% 25%, white, transparent), radial-gradient(1.5px 1.5px at 80% 20%, white, transparent), radial-gradient(1px 1px at 30% 75%, white, transparent), radial-gradient(1px 1px at 70% 70%, white, transparent)', backgroundSize: '220px 220px' }} />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-xs font-semibold mb-8"
               style={{ background: 'rgba(0,122,255,0.15)', border: '1px solid rgba(0,122,255,0.35)', color: '#93C5FD' }}>
            <Moon size={13} /> Ayah of the Day — Surah An-Nisa, 4:136
          </div>
          <p dir="rtl" lang="ar" className="text-2xl sm:text-3xl leading-loose text-white font-semibold mb-8" style={{ fontFamily: '"Traditional Arabic", "Scheherazade New", serif' }}>
            يَا أَيُّهَا الَّذِينَ آمَنُوا آمِنُوا بِاللَّهِ وَرَسُولِهِ وَالْكِتَابِ الَّذِي نَزَّلَ عَلَى رَسُولِهِ وَالْكِتَابِ الَّذِي أَنزَلَ مِن قَبْلُ ۚ وَمَن يَكْفُرْ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ وَالْيَوْمِ الْآخِرِ فَقَدْ ضَلَّ ضَلَالًا بَعِيدًا
          </p>
          <p className="text-white/80 text-base sm:text-lg max-w-2xl mx-auto leading-relaxed mb-2">
            "O you who believe! Believe in Allah, His Messenger, the Book He revealed to His Messenger, and the Books
            He revealed before. Whoever disbelieves in Allah, His angels, His Books, His Messengers, and the Last Day
            has strayed far into error."
          </p>
          <p className="text-white/50 text-sm mb-8">Surah An-Nisa (4:136)</p>
          <button onClick={onGetStarted}
            className="px-6 py-3 rounded-2xl text-sm font-bold text-white inline-flex items-center gap-2 transition-all hover:scale-105 active:scale-95"
            style={{ background: 'linear-gradient(135deg,#007AFF,#0052AD)', boxShadow: '0 8px 32px rgba(0,82,173,0.5)' }}>
            Study This Ayah — Chapter 1 <ArrowRight size={16}/>
          </button>
        </div>
      </section>

      {/* ── Featured Scholars ── */}
      <section id="courses" className="py-24 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-14">
            <Eyebrow>Sources & References</Eyebrow>
            <h2 className="text-3xl sm:text-4xl font-black text-slate-900 mt-4 tracking-tight">Grounded in Authentic Scholarship</h2>
            <p className="text-slate-500 mt-3 max-w-xl mx-auto">Every lesson is built on the recognized tafseer and translation work of these scholars.</p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {FEATURED_SCHOLARS.map((s, i) => (
              <div key={i} className="card card-hover overflow-hidden group cursor-pointer" onClick={onGetStarted}>
                <div className="h-24 relative overflow-hidden flex items-center justify-center"
                     style={{ background: 'linear-gradient(135deg,#0052AD,#007AFF)' }}>
                  <div className="w-14 h-14 rounded-2xl bg-white/15 border border-white/20 flex items-center justify-center text-white group-hover:scale-110 transition-transform duration-500">
                    {s.icon}
                  </div>
                </div>
                <div className="p-5">
                  <h3 className="font-bold text-slate-800 mb-1 group-hover:text-brand-700 transition-colors">{s.name}</h3>
                  <p className="text-sm text-primary-600 font-semibold mb-1">{s.work}</p>
                  <p className="text-xs text-slate-500">{s.note}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Learning Categories ── */}
      <section id="categories" className="py-24 bg-[#fbf8f4]">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-14">
            <Eyebrow>Learning Categories</Eyebrow>
            <h2 className="text-3xl sm:text-4xl font-black text-slate-900 mt-4 tracking-tight">Explore by Subject</h2>
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-5">
            {CATEGORIES.map((c) => (
              <button key={c.label} onClick={onGetStarted}
                className="card card-hover flex flex-col items-center gap-3 py-7 px-4 text-center group">
                <div className="w-12 h-12 rounded-2xl flex items-center justify-center text-brand-700 bg-brand-50 group-hover:bg-brand-100 group-hover:scale-110 transition-all">
                  {c.icon}
                </div>
                <span className="text-sm font-bold text-slate-700">{c.label}</span>
              </button>
            ))}
          </div>
        </div>
      </section>

      {/* ── Why Choose Iman Ki Shama ── */}
      <section id="features" className="py-24 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <Eyebrow>Why Choose Iman Ki Shama</Eyebrow>
            <h2 className="text-3xl sm:text-4xl font-black text-slate-900 mt-4 tracking-tight">Everything You Need to Learn</h2>
            <p className="text-slate-500 mt-3 max-w-xl mx-auto">Built for students, teachers, parents, and administrators alike.</p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {FEATURES.map((f, i) => (
              <div key={i} className="card p-6 card-hover group">
                <div className="w-12 h-12 rounded-2xl flex items-center justify-center mb-4 text-primary-700 bg-primary-50 group-hover:bg-primary-100 transition-colors">
                  {f.icon}
                </div>
                <h3 className="font-bold text-slate-800 mb-2">{f.title}</h3>
                <p className="text-sm text-slate-500 leading-relaxed">{f.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Learning Process ── */}
      <section id="process" className="py-24" style={{ background: 'linear-gradient(180deg,#fbf8f4 0%,#fdf3f2 100%)' }}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <Eyebrow>How It Works</Eyebrow>
            <h2 className="text-3xl sm:text-4xl font-black text-slate-900 mt-4 tracking-tight">Your Learning Journey</h2>
          </div>
          <div className="flex flex-col lg:flex-row items-stretch justify-between gap-6 lg:gap-3">
            {PROCESS_STEPS.map((s, i) => (
              <div key={s.label} className="flex lg:flex-col items-center lg:text-center gap-4 lg:gap-3 flex-1 relative">
                <div className="w-14 h-14 shrink-0 rounded-2xl flex items-center justify-center text-white font-bold shadow-md"
                     style={{ background: 'linear-gradient(135deg,#007AFF,#0052AD)' }}>
                  {s.icon}
                </div>
                <div className="lg:flex-1">
                  <p className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Step {i + 1}</p>
                  <p className="font-bold text-slate-800">{s.label}</p>
                </div>
                {i < PROCESS_STEPS.length - 1 && (
                  <div className="hidden lg:block absolute top-7 left-[calc(50%+2rem)] right-[calc(-50%+2rem)] h-px bg-gradient-to-r from-primary-300 to-transparent" />
                )}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Interactive Demo Preview ── */}
      <section className="py-24 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-14">
            <Eyebrow>See It In Action</Eyebrow>
            <h2 className="text-3xl sm:text-4xl font-black text-slate-900 mt-4 tracking-tight">A Peek Inside Iman Ki Shama</h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="card p-6">
              <div className="flex items-center gap-2 mb-4">
                <LineChart size={18} className="text-primary-600" />
                <p className="font-bold text-slate-800 text-sm">Course Progress</p>
              </div>
              <div className="space-y-3">
                {['Mathematics', 'Science', 'Programming'].map((s, i) => (
                  <div key={s}>
                    <div className="flex justify-between text-xs text-slate-500 mb-1">
                      <span>{s}</span><span className="font-semibold text-slate-700">{[72, 54, 88][i]}%</span>
                    </div>
                    <div className="h-1.5 bg-slate-100 rounded-full overflow-hidden">
                      <div className="h-full rounded-full bg-gradient-to-r from-primary-500 to-primary-400" style={{ width: `${[72, 54, 88][i]}%` }} />
                    </div>
                  </div>
                ))}
              </div>
            </div>
            <div className="card p-6">
              <div className="flex items-center gap-2 mb-4">
                <FileCheck2 size={18} className="text-brand-700" />
                <p className="font-bold text-slate-800 text-sm">Quiz Preview</p>
              </div>
              <p className="text-sm text-slate-600 font-medium mb-3">Which planet is known as the Red Planet?</p>
              <div className="space-y-2">
                {['Venus', 'Mars', 'Jupiter'].map((opt, i) => (
                  <div key={opt} className={`px-3 py-2 rounded-xl text-sm border ${i === 1 ? 'border-success-300 bg-success-50 text-success-700 font-semibold' : 'border-slate-200 text-slate-600'}`}>
                    {opt}
                  </div>
                ))}
              </div>
            </div>
            <div className="card p-6">
              <div className="flex items-center gap-2 mb-4">
                <Radio size={18} className="text-rose-500" />
                <p className="font-bold text-slate-800 text-sm">Live Classroom</p>
              </div>
              <div className="rounded-xl h-28 flex items-center justify-center mb-3" style={{ background: 'linear-gradient(135deg,#00182F,#00284F)' }}>
                <PlayCircle size={32} className="text-white/70" />
              </div>
              <div className="flex items-center gap-1.5 text-xs font-bold text-rose-500">
                <span className="w-1.5 h-1.5 rounded-full bg-rose-500 animate-pulse" /> Live in 12 minutes
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ── Testimonials ── */}
      <section className="py-24" style={{ background: 'linear-gradient(135deg,#00182F 0%,#00284F 100%)' }}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl sm:text-4xl font-black text-white">Loved by Students, Teachers & Parents</h2>
            <p className="text-white/60 mt-3">Real feedback from the Iman Ki Shama community</p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {TESTIMONIALS.map((t, i) => (
              <div key={i} className="rounded-2xl p-6" style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.1)' }}>
                <div className="flex items-center gap-1 mb-4">
                  {[...Array(5)].map((_, i) => <Star key={i} size={14} className="fill-amber-400 text-amber-400" />)}
                </div>
                <p className="text-white/80 text-sm leading-relaxed mb-5">"{t.text}"</p>
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full flex items-center justify-center text-white text-xs font-bold" style={{ background: 'linear-gradient(135deg,#007AFF,#0052AD)' }}>
                    {t.name.split(' ').map(w => w[0]).join('').slice(0, 2)}
                  </div>
                  <div>
                    <p className="text-sm font-semibold text-white">{t.name}</p>
                    <p className="text-xs text-white/50">{t.role}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Achievements ── */}
      <section className="py-16 bg-[#fbf8f4] border-y border-slate-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-6">
            {ACHIEVEMENTS.map((a, i) => (
              <div key={i} className="flex items-center gap-3 p-4 rounded-2xl bg-white shadow-sm border border-slate-100">
                <div className="w-11 h-11 rounded-xl bg-primary-50 text-primary-700 flex items-center justify-center shrink-0">
                  {a.icon}
                </div>
                <p className="text-sm font-bold text-slate-700 leading-tight">{a.label}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Latest Courses Slider ── */}
      <section className="py-24 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-end justify-between mb-10">
            <div>
              <Eyebrow>Fresh Content</Eyebrow>
              <h2 className="text-3xl sm:text-4xl font-black text-slate-900 mt-4">Latest Courses</h2>
            </div>
          </div>
          <div className="flex gap-5 overflow-x-auto pb-4 -mx-4 px-4 sm:mx-0 sm:px-0 scrollbar-hide snap-x snap-mandatory">
            {LATEST_COURSES.map((c, i) => (
              <div key={i} onClick={onGetStarted} className="card card-hover shrink-0 w-64 p-5 snap-start cursor-pointer">
                <div className="w-11 h-11 rounded-xl flex items-center justify-center text-white mb-4" style={{ background: 'linear-gradient(135deg,#0052AD,#007AFF)' }}>
                  {c.icon}
                </div>
                <p className="text-xs font-bold text-primary-700 uppercase tracking-wide mb-1">{c.subject}</p>
                <p className="font-bold text-slate-800 text-sm leading-snug">{c.title}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Latest News ── */}
      <section className="py-24 bg-[#fbf8f4]">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-14">
            <Eyebrow>News</Eyebrow>
            <h2 className="text-3xl sm:text-4xl font-black text-slate-900 mt-4 tracking-tight">Latest from Iman Ki Shama</h2>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
            {NEWS.map((n, i) => (
              <div key={i} className="card p-6">
                <div className="w-11 h-11 rounded-xl bg-brand-50 text-brand-700 flex items-center justify-center mb-4">
                  {n.icon}
                </div>
                <p className="text-xs text-slate-400 font-semibold mb-2">{n.date}</p>
                <p className="font-bold text-slate-800 leading-snug">{n.title}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── FAQ ── */}
      <section id="faq" className="py-24 bg-white">
        <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <Eyebrow>FAQ</Eyebrow>
            <h2 className="text-3xl font-black text-slate-900 mt-4">Frequently Asked Questions</h2>
          </div>
          <div className="space-y-3">
            {FAQS.map((f, i) => (
              <div key={i} className="card overflow-hidden">
                <button className="w-full flex items-center justify-between px-6 py-4 text-left" onClick={() => setOpenFaq(openFaq === i ? null : i)}>
                  <span className="font-semibold text-slate-800 text-sm">{f.q}</span>
                  <ChevronDown size={18} className={`text-slate-400 transition-transform duration-200 shrink-0 ml-4 ${openFaq === i ? 'rotate-180' : ''}`} />
                </button>
                {openFaq === i && (
                  <div className="px-6 pb-5 text-sm text-slate-500 leading-relaxed border-t border-slate-50 pt-3">
                    {f.a}
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Newsletter ── */}
      <section className="py-20" style={{ background: 'linear-gradient(135deg,#007AFF 0%,#0052AD 100%)' }}>
        <div className="max-w-3xl mx-auto px-4 text-center">
          <Mail size={28} className="text-white mx-auto mb-4" />
          <h2 className="text-2xl sm:text-3xl font-black text-white mb-3 tracking-tight">Stay in the Loop</h2>
          <p className="text-white/85 mb-8">Get new course announcements and learning tips straight to your inbox.</p>
          {subscribed ? (
            <p className="inline-flex items-center gap-2 px-5 py-3 rounded-2xl bg-white/20 text-white font-semibold">
              <CheckCircle2 size={18}/> Subscribed! Thanks for joining.
            </p>
          ) : (
            <form onSubmit={handleSubscribe} className="flex flex-col sm:flex-row gap-3 max-w-md mx-auto">
              <input
                type="email" required placeholder="you@example.com"
                value={newsletterEmail} onChange={(e) => setNewsletterEmail(e.target.value)}
                className="flex-1 px-4 py-3 rounded-xl text-sm bg-white/95 text-slate-800 placeholder-slate-400 outline-none focus:ring-2 focus:ring-white/60"
              />
              <button type="submit" className="px-6 py-3 rounded-xl text-sm font-bold bg-slate-900 text-white hover:bg-slate-800 transition-colors active:scale-95">
                Subscribe
              </button>
            </form>
          )}
        </div>
      </section>

      {/* ── CTA ── */}
      <section className="py-24 bg-white">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <h2 className="text-3xl sm:text-5xl font-black text-slate-900 mb-4 tracking-tight">Ready to Start Learning?</h2>
          <p className="text-lg text-slate-500 mb-8">Join thousands of students and teachers already growing with Iman Ki Shama.</p>
          <button onClick={onGetStarted}
            className="px-10 py-4 rounded-2xl text-white font-bold text-lg hover:scale-105 active:scale-95 transition-all"
            style={{ background: 'linear-gradient(135deg,#007AFF,#0052AD)', boxShadow: '0 8px 32px rgba(0,82,173,0.4)' }}>
            Get Started for Free <ArrowRight size={20} className="inline ml-1" />
          </button>
        </div>
      </section>

      {/* ── Footer ── */}
      <footer className="py-16" style={{ background: 'linear-gradient(180deg,#00182F 0%,#0f0a09 100%)' }}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-2 md:grid-cols-5 gap-8 mb-12">
            <div className="col-span-2">
              <div className="bg-white rounded-xl px-2 py-1.5 inline-block mb-4">
                <img src="/assets/imaan-ki-shama-logo.png" alt="Iman Ki Shama" className="h-8 w-auto object-contain" />
              </div>
              <p className="text-white/50 text-sm leading-relaxed max-w-xs mb-4">
                A modern, AI-powered learning management system by Iman Ki Shama.
              </p>
              <div className="flex gap-3">
                {[Share2, AtSign, Link2, Camera].map((Icon, i) => (
                  <a key={i} href="#" className="w-9 h-9 rounded-lg bg-white/10 hover:bg-white/20 flex items-center justify-center text-white/70 hover:text-white transition-colors">
                    <Icon size={15} />
                  </a>
                ))}
              </div>
            </div>
            <div>
              <p className="text-white font-bold text-sm mb-4">Platform</p>
              <ul className="space-y-2.5 text-sm text-white/50">
                <li><a href="#features" className="hover:text-white transition-colors">Features</a></li>
                <li><a href="#courses" className="hover:text-white transition-colors">Courses</a></li>
                <li><a href="#categories" className="hover:text-white transition-colors">Categories</a></li>
              </ul>
            </div>
            <div>
              <p className="text-white font-bold text-sm mb-4">Resources</p>
              <ul className="space-y-2.5 text-sm text-white/50">
                <li><a href="#faq" className="hover:text-white transition-colors">FAQ</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Support</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Contact</a></li>
              </ul>
            </div>
            <div>
              <p className="text-white font-bold text-sm mb-4">Contact</p>
              <ul className="space-y-2.5 text-sm text-white/50">
                <li className="flex items-center gap-2"><Mail size={14}/> hello@zilearn.io</li>
                <li className="flex items-center gap-2"><MapPin size={14}/> Lagos, Nigeria</li>
              </ul>
            </div>
          </div>
          <div className="flex flex-col md:flex-row items-center justify-between gap-4 pt-8 border-t border-white/10">
            <p className="text-white/40 text-xs">© 2026 Iman Ki Shama by Iman Ki Shama. All rights reserved.</p>
            <div className="flex gap-5 text-xs text-white/40">
              <a href="#" className="hover:text-white transition-colors">Privacy Policy</a>
              <a href="#" className="hover:text-white transition-colors">Terms of Service</a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
