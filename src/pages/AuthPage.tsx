// NOTE: Demo accounts (admin@demo.com, professor@demo.com, student@demo.com) with password 'demo1234' must exist in Supabase auth.
// Create them via Supabase dashboard or CLI before using demo login buttons.

import { Eye, EyeOff, Mail, Lock, User, AlertCircle, ShieldCheck, Users as UsersIcon, BookOpen, GraduationCap, Sparkles, Award, PlayCircle, ArrowLeft } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useState } from 'react';

type Mode = 'login' | 'register' | 'forgot';

const DEMO_ACCOUNTS = [
  { role: 'Admin',     email: 'admin@demo.com',     password: 'demo1234', icon: <ShieldCheck size={20} />, color: 'from-violet-500 to-purple-600', bg: 'hover:bg-violet-50 hover:border-violet-300', text: 'text-violet-700', badge: 'bg-violet-100 text-violet-700' },
  { role: 'Professor', email: 'professor@demo.com', password: 'demo1234', icon: <BookOpen size={20} />,    color: 'from-sky-500 to-blue-600',    bg: 'hover:bg-sky-50 hover:border-sky-300',       text: 'text-sky-700',    badge: 'bg-sky-100 text-sky-700' },
  { role: 'Student',   email: 'student@demo.com',   password: 'demo1234', icon: <UsersIcon size={20} />,   color: 'from-emerald-500 to-teal-600', bg: 'hover:bg-emerald-50 hover:border-emerald-300', text: 'text-emerald-700', badge: 'bg-emerald-100 text-emerald-700' },
];

export default function AuthPage({ onBack }: { onBack?: () => void } = {}) {
  const [mode, setMode] = useState<Mode>('login');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [showPw, setShowPw] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [rememberMe, setRememberMe] = useState(true);

  const reset = () => { setError(''); setSuccess(''); };

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault(); reset(); setLoading(true);
    const { error: e2 } = await supabase.auth.signInWithPassword({ email, password });
    setLoading(false);
    if (e2) setError(e2.message);
  }

  async function handleRegister(e: React.FormEvent) {
    e.preventDefault(); reset(); setLoading(true);
    const { error: e2 } = await supabase.auth.signUp({
      email, password,
      options: { data: { full_name: name, role: 'student' } },
    });
    setLoading(false);
    if (e2) setError(e2.message);
    else setSuccess('Account created! Check your email to verify.');
  }

  async function handleForgot(e: React.FormEvent) {
    e.preventDefault(); reset(); setLoading(true);
    const { error: e2 } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: window.location.origin,
    });
    setLoading(false);
    if (e2) setError(e2.message);
    else setSuccess('Password reset email sent! Check your inbox.');
  }
const handleDemoLogin = async (demoEmail: string, demoPassword: string) => {
  setEmail(demoEmail);
  setPassword(demoPassword);
  const { error } = await supabase.auth.signInWithPassword({ email: demoEmail, password: demoPassword });
  if (error) setError(error.message);
  else setSuccess('Logged in!');
};
  const submit = mode === 'login' ? handleLogin : mode === 'register' ? handleRegister : handleForgot;

  const PANELS = [
    { label: 'Sign In',      mode: 'login'    as Mode },
    { label: 'Create Account',mode: 'register' as Mode },
  ];

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-8 sm:px-6 sm:py-12 relative overflow-hidden"
         style={{ background: 'linear-gradient(155deg,#021730 0%,#052f5c 30%,#063b73 65%,#0878f9 100%)' }}>

      {/* Ambient glow + dot texture (no screenshot used, pure CSS) */}
      <div className="absolute inset-0 opacity-70" style={{
        background: 'radial-gradient(circle at 50% 15%, rgba(255,255,255,0.20), transparent 55%)',
      }} />
      <div className="absolute inset-0 opacity-30" style={{
        backgroundImage: 'radial-gradient(1.5px 1.5px at 10% 20%, white, transparent), radial-gradient(1.5px 1.5px at 85% 15%, white, transparent), radial-gradient(1px 1px at 25% 80%, white, transparent), radial-gradient(1px 1px at 70% 75%, white, transparent), radial-gradient(1.5px 1.5px at 92% 60%, white, transparent), radial-gradient(1px 1px at 5% 55%, white, transparent), radial-gradient(1.5px 1.5px at 55% 90%, white, transparent)',
        backgroundSize: '260px 260px',
      }} />
      <div className="absolute -top-20 -left-20 w-96 h-96 rounded-full opacity-40 animate-float" style={{ background: 'radial-gradient(circle,#0878f9,transparent 70%)' }} />
      <div className="absolute -bottom-24 -right-10 w-[28rem] h-[28rem] rounded-full opacity-30" style={{ background: 'radial-gradient(circle,#3894fc,transparent 70%)', animation: 'float 9s ease-in-out infinite reverse' }} />
      <div className="absolute top-1/3 right-1/4 w-56 h-56 rounded-full opacity-20" style={{ background: 'radial-gradient(circle,#9fc1dd,transparent 70%)', animation: 'float 11s ease-in-out infinite' }} />

      <div className="relative z-10 w-full max-w-6xl flex items-center justify-center gap-12 xl:gap-20">

        {/* Decorative educational illustration panel (desktop only) */}
        <div className="hidden lg:flex flex-1 flex-col justify-center max-w-md text-white animate-fade-up">
          <div className="flex items-center gap-2 mb-6">
            <span className="w-2 h-2 rounded-full bg-white/80 animate-pulse" />
            <span className="text-xs font-bold tracking-widest uppercase text-white/80">Imaan Ki Shama LMS</span>
          </div>
          <h1 className="text-4xl font-black leading-tight tracking-tight mb-4">
            Nurturing faith,<br />
            <span style={{ background: 'linear-gradient(90deg,#eaf4ff,#9fccff)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
              nurturing knowledge.
            </span>
          </h1>
          <p className="text-white/85 text-base leading-relaxed mb-10 max-w-sm">
            Courses, live classes, assignments, and certificates — all in one beautifully organized place.
          </p>

          {/* Floating icon cards illustrating the platform */}
          <div className="relative h-56">
            <div className="absolute left-0 top-0 w-40 rounded-2xl p-4 bg-white/15 border border-white/25 backdrop-blur-sm shadow-lg animate-float" style={{ animationDelay: '0s' }}>
              <GraduationCap size={22} className="text-white mb-2" />
              <p className="text-xs font-bold text-white">Guided Courses</p>
              <p className="text-[11px] text-white/70 mt-0.5">Structured, step-by-step</p>
            </div>
            <div className="absolute right-0 top-8 w-40 rounded-2xl p-4 bg-white/15 border border-white/25 backdrop-blur-sm shadow-lg animate-float" style={{ animationDelay: '1.2s' }}>
              <Sparkles size={22} className="text-white mb-2" />
              <p className="text-xs font-bold text-white">AI-Assisted</p>
              <p className="text-[11px] text-white/70 mt-0.5">Smart study insights</p>
            </div>
            <div className="absolute left-10 bottom-0 w-40 rounded-2xl p-4 bg-white/15 border border-white/25 backdrop-blur-sm shadow-lg animate-float" style={{ animationDelay: '2.1s' }}>
              <Award size={22} className="text-white mb-2" />
              <p className="text-xs font-bold text-white">Certificates</p>
              <p className="text-[11px] text-white/70 mt-0.5">Verified on completion</p>
            </div>
            <div className="absolute right-6 bottom-2 w-40 rounded-2xl p-4 bg-white/15 border border-white/25 backdrop-blur-sm shadow-lg animate-float" style={{ animationDelay: '0.6s' }}>
              <PlayCircle size={22} className="text-white mb-2" />
              <p className="text-xs font-bold text-white">Live Classes</p>
              <p className="text-[11px] text-white/70 mt-0.5">Real-time & recorded</p>
            </div>
          </div>
        </div>

      {/* Card */}
      <div className="relative z-10 w-full max-w-md rounded-[2rem] p-[2px]" style={{ background: 'linear-gradient(135deg,#063b73,#0878f9,#9fc1dd)', boxShadow: '0 24px 70px rgba(6,59,115,0.45)' }}>
      <div className="bg-white rounded-[calc(2rem-2px)] px-6 py-8 sm:px-10 sm:py-10">

        {onBack && (
          <button onClick={onBack} className="flex items-center gap-1.5 text-sm font-semibold text-slate-500 hover:text-brand-700 transition-colors mb-4">
            <ArrowLeft size={15} /> Back to home
          </button>
        )}

        {/* Logo + brand */}
        <div className="flex justify-center mb-6">
          <img src="/assets/imaan-ki-shama-logo.png" alt="Imaan Ki Shama" className="h-14 sm:h-16 w-auto object-contain" />
        </div>

        {/* Tab switcher */}
        {mode !== 'forgot' && (
          <div className="flex gap-1 p-1 bg-brand-50 rounded-2xl mb-6">
            {PANELS.map(p => (
              <button key={p.mode} type="button" onClick={() => { setMode(p.mode); reset(); }}
                className={`flex-1 py-2.5 rounded-xl text-sm font-semibold transition-all duration-200 ${
                  mode === p.mode ? 'bg-white text-brand-700 shadow-sm' : 'text-brand-400 hover:text-brand-600'
                }`}>
                {p.label}
              </button>
            ))}
          </div>
        )}

        {/* Heading */}
        <div className="mb-6 text-center">
          <h2 className="text-2xl sm:text-3xl font-bold text-gradient-brand tracking-tight">
            {mode === 'login' ? 'Welcome Back' : mode === 'register' ? 'Create your account' : 'Forgot password?'}
          </h2>
          <p className="text-slate-500 text-sm mt-2 leading-relaxed">
            {mode === 'login' ? (
              <>Sign in to continue your learning journey with{' '}<span className="text-accent-600 font-semibold">Imaan Ki Shama</span>.</>
            ) : mode === 'register' ? (
              <>Join <span className="text-accent-600 font-semibold">Imaan Ki Shama</span> and start learning today.</>
            ) : (
              "Enter your email and we'll send a reset link"
            )}
          </p>
        </div>

        {/* Demo Accounts (login only) */}
        {mode === 'login' && (
          <div className="mb-6">
            <div className="grid grid-cols-3 gap-2.5">
              {DEMO_ACCOUNTS.map(acc => (
                <button
                  key={acc.role}
                  type="button"
                  onClick={() => handleDemoLogin(acc.email, acc.password)}
                  className={`flex flex-col items-center gap-2 py-4 px-2 rounded-2xl border-2 border-slate-200 bg-white transition-all text-center ${acc.bg}`}
                >
                  <span className={`w-10 h-10 rounded-full bg-gradient-to-br ${acc.color} flex items-center justify-center text-white shadow-sm`}>
                    {acc.icon}
                  </span>
                  <span className="text-xs font-bold text-slate-600 leading-tight truncate w-full text-center">{acc.role}</span>
                </button>
              ))}
            </div>
            <p className="text-xs text-slate-400 font-medium text-center mt-3">Password: <span className="font-mono font-bold text-slate-600">demo1234</span></p>
          </div>
        )}

        {/* Divider */}
        {mode !== 'forgot' && (
          <div className="flex items-center gap-3 mb-6">
            <div className="flex-1 h-px bg-slate-200" />
            <span className="text-xs text-slate-400 font-bold tracking-widest">OR EMAIL</span>
            <div className="flex-1 h-px bg-slate-200" />
          </div>
        )}

        {/* Form */}
        <form onSubmit={submit} className="space-y-4">
          {mode === 'register' && (
            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-1.5">Full Name</label>
              <div className="relative">
                <User size={17} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-brand-500" />
                <input
                  className="w-full border-2 border-slate-200 rounded-xl pl-10 pr-4 py-3 text-sm bg-white text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-accent-400/40 focus:border-accent-400 transition-colors"
                  placeholder="John Doe" value={name} onChange={e => setName(e.target.value)} required
                />
              </div>
            </div>
          )}
          <div>
            <label className="block text-sm font-semibold text-slate-700 mb-1.5">Email</label>
            <div className="relative">
              <Mail size={17} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-brand-500" />
              <input
                className="w-full border-2 border-slate-200 rounded-xl pl-10 pr-4 py-3 text-sm bg-white text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-accent-400/40 focus:border-accent-400 transition-colors"
                type="email" placeholder="Enter your email" value={email} onChange={e => setEmail(e.target.value)} required
              />
            </div>
          </div>
          {mode !== 'forgot' && (
            <div>
              <div className="flex justify-between items-center mb-1.5">
                <label className="block text-sm font-semibold text-slate-700 mb-0">Password</label>
              </div>
              <div className="relative">
                <Lock size={17} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-brand-500" />
                <input
                  className="w-full border-2 border-slate-200 rounded-xl pl-10 pr-11 py-3 text-sm bg-white text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-accent-400/40 focus:border-accent-400 transition-colors"
                  type={showPw ? 'text' : 'password'} placeholder="Enter your password" value={password} onChange={e => setPassword(e.target.value)} required minLength={6}
                />
                <button type="button" onClick={() => setShowPw(!showPw)} className="absolute right-3.5 top-1/2 -translate-y-1/2 text-brand-400 hover:text-brand-600 transition-colors">
                  {showPw ? <EyeOff size={17}/> : <Eye size={17}/>}
                </button>
              </div>
            </div>
          )}

          {mode === 'login' && (
            <div className="flex items-center justify-between">
              <label className="flex items-center gap-2.5 cursor-pointer select-none">
                <input type="checkbox" checked={rememberMe} onChange={(e) => setRememberMe(e.target.checked)}
                  className="w-4 h-4 rounded border-slate-300 text-accent-600 focus:ring-accent-400/50" />
                <span className="text-sm text-slate-600 font-medium">Keep me signed in</span>
              </label>
              <button type="button" onClick={() => setMode('forgot')} className="text-sm text-brand-600 hover:text-brand-700 font-semibold transition-colors">
                Forgot Password?
              </button>
            </div>
          )}

          {/* Error / Success */}
          {error && (
            <div className="flex items-center gap-2.5 p-3.5 rounded-xl bg-danger-50 border border-danger-100 text-danger-700 text-sm animate-fade-up">
              <AlertCircle size={16} className="shrink-0" /> {error}
            </div>
          )}
          {success && (
            <div className="flex items-center gap-2.5 p-3.5 rounded-xl bg-success-50 border border-success-100 text-success-700 text-sm animate-fade-up">
              ✓ {success}
            </div>
          )}

          <button type="submit" disabled={loading}
            className="w-full flex items-center justify-center gap-2 py-3.5 rounded-xl font-bold text-sm text-white transition-all hover:opacity-90 active:scale-95 disabled:opacity-60 mt-2"
            style={{ background: 'linear-gradient(135deg,#0878f9,#0660c9)', boxShadow: '0 4px 18px rgba(8,120,249,0.45)' }}>
            {loading ? (
              <div className="w-5 h-5 rounded-full border-2 border-white/30 border-t-white animate-spin" />
            ) : (
              mode === 'login' ? 'Sign In' : mode === 'register' ? 'Create Account' : 'Send Reset Link'
            )}
          </button>
        </form>

        {mode === 'forgot' && (
          <button onClick={() => { setMode('login'); reset(); }} className="mt-4 w-full text-center text-sm text-slate-500 hover:text-brand-600 transition-colors font-medium">
            ← Back to Sign In
          </button>
        )}

        {mode === 'login' && (
          <p className="text-sm text-slate-500 text-center mt-6">
            Don't have an account?{' '}
            <button onClick={() => { setMode('register'); reset(); }} className="text-brand-600 font-semibold hover:text-brand-700 transition-colors">
              Sign up
            </button>
          </p>
        )}

        <p className="text-[11px] text-slate-400 text-center mt-8 tracking-wide">
          © 2026 IMAAN KI SHAMA
        </p>
      </div>
      </div>
      </div>
    </div>
  );
}
