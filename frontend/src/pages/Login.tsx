import React, { useState } from 'react';
import { Container, Box, Typography, TextField, Button, Paper, InputAdornment, IconButton } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useCustomTheme } from '../context/ThemeContext';
import axios from 'axios';
import logo from '../assets/logo.png';
import loginBg from '../assets/login-bg.png';
import Visibility from '@mui/icons-material/Visibility';
import VisibilityOff from '@mui/icons-material/VisibilityOff';
import DarkModeIcon from '@mui/icons-material/DarkMode';
import LightModeIcon from '@mui/icons-material/LightMode';

const API_URL = `${import.meta.env.VITE_API_URL}/auth/login`;

const LoginPage = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  // El backend puede estar "dormido" (plan gratuito) y tardar en responder la primera vez
  const [isSlow, setIsSlow] = useState(false);
  const navigate = useNavigate();
  const { login, showNotification } = useAuth();
  const { mode, toggleTheme } = useCustomTheme();


  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setIsLoading(true);
    const slowTimer = setTimeout(() => setIsSlow(true), 5000);
    try {
      const response = await axios.post(API_URL, {
        email: email,
        contrasena: password,
      }, { timeout: 90000 });
      login(response.data.token);
      navigate('/dashboard');
    } catch (err) {
      if (axios.isAxiosError(err) && err.response) {
        if (err.response.status === 401) {
          showNotification('Correo o contraseña incorrectos.', 'error');
        } else {
          const message = (err.response.data as { message?: string })?.message;
          showNotification(message || `Error del servidor (${err.response.status}). Intenta más tarde.`, 'error');
        }
      } else {
        // Sin respuesta: servidor caído, sin conexión, CORS o tiempo de espera agotado
        showNotification('No se pudo conectar con el servidor. Revisa tu conexión e intenta de nuevo.', 'error');
      }
    } finally {
      clearTimeout(slowTimer);
      setIsLoading(false);
      setIsSlow(false);
    }
  };

  return (
    <Box
      sx={{
        minHeight: '100vh',
        backgroundImage: `url(${loginBg})`,
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        position: 'relative',
        '&::before': {
          content: '""',
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          backgroundColor: mode === 'dark' ? 'rgba(0, 0, 0, 0.6)' : 'rgba(255, 255, 255, 0.3)',
          backdropFilter: 'blur(3px)',
        }
      }}
    >
      {/* Theme Toggle */}
      <Box sx={{ position: 'absolute', top: 16, right: 16, zIndex: 10 }}>
        <IconButton onClick={toggleTheme} sx={{ color: mode === 'dark' ? 'white' : 'primary.main', bgcolor: 'rgba(255,255,255,0.1)', backdropFilter: 'blur(5px)' }}>
          {mode === 'dark' ? <LightModeIcon /> : <DarkModeIcon />}
        </IconButton>
      </Box>

      <Container component="main" maxWidth="xs" sx={{ position: 'relative', zIndex: 1 }}>
        <Paper
          elevation={24}
          sx={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            padding: 4,
            backgroundColor: mode === 'dark' ? 'rgba(30, 17, 21, 0.75)' : 'rgba(255, 255, 255, 0.85)',
            backdropFilter: 'blur(10px)',
            border: `1px solid ${mode === 'dark' ? 'rgba(212, 175, 55, 0.2)' : 'rgba(212, 175, 55, 0.5)'}`,
            borderRadius: 4,
          }}
        >
          <Box sx={{ mb: 2, textAlign: 'center' }}>
            <img src={logo} alt="VinoVault Logo" style={{ height: '300px', filter: mode === 'dark' ? 'drop-shadow(0 0 10px rgba(212,175,55,0.3))' : 'none' }} />
          </Box>

          <Typography component="h5" variant="h5" sx={{
            fontFamily: 'Playfair Display',
            color: 'primary.main',
            mb: 1,
            fontWeight: 700
          }}>
            Gestión de Bodegas
          </Typography>

          <Box component="form" onSubmit={handleSubmit} sx={{ mt: 1, width: '100%' }}>
            <TextField
              margin="normal"
              required
              fullWidth
              id="email"
              label="Correo Electrónico"
              name="email"
              autoComplete="email"
              autoFocus
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              sx={{
                '& .MuiOutlinedInput-root': {
                  '& fieldset': { borderColor: mode === 'dark' ? 'rgba(255, 255, 255, 0.2)' : 'rgba(0, 0, 0, 0.2)' },
                  '&:hover fieldset': { borderColor: 'primary.main' },
                }
              }}
            />
            <TextField
              margin="normal"
              required
              fullWidth
              name="password"
              label="Contraseña"
              type={showPassword ? 'text' : 'password'}
              id="password"
              autoComplete="current-password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              InputProps={{
                endAdornment: (
                  <InputAdornment position="end">
                    <IconButton
                      aria-label="toggle password visibility"
                      onClick={() => setShowPassword(!showPassword)}
                      edge="end"
                    >
                      {showPassword ? <VisibilityOff /> : <Visibility />}
                    </IconButton>
                  </InputAdornment>
                ),
              }}
              sx={{
                '& .MuiOutlinedInput-root': {
                  '& fieldset': { borderColor: mode === 'dark' ? 'rgba(255, 255, 255, 0.2)' : 'rgba(0, 0, 0, 0.2)' },
                  '&:hover fieldset': { borderColor: 'primary.main' },
                }
              }}
            />
            <Button
              type="submit"
              fullWidth
              variant="contained"
              size="large"
              disabled={isLoading}
              sx={{ mt: 4, mb: 2, py: 1.5, fontSize: '1.1rem' }}
            >
              {isLoading ? (isSlow ? 'Iniciando servidor…' : 'Ingresando…') : 'Ingresar'}
            </Button>
            {isSlow && (
              <Typography variant="body2" sx={{ textAlign: 'center', color: 'text.secondary' }}>
                El servidor se está iniciando. La primera conexión puede tardar hasta un minuto.
              </Typography>
            )}
          </Box>
        </Paper>
      </Container>
    </Box>
  );
};

export default LoginPage;