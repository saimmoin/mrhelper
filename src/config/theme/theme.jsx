import { createTheme, responsiveFontSizes } from '@mui/material/styles'

let lightTheme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#005272',
    },
  },
  breakpoints: {
    values: {
      xs: 0,
      sm: 600,
      md: 900,
      lg: 1280,
      xl: 1920,
    },
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          textTransform: 'none',
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          borderRadius: 10,
          // "& fieldset": {
          //   borderWidth: "0px !important",
          // },
          '& input': {
            fontWeight: 600,
          },
        },
      },
    },
  },
  boxShadows: ['0px 5px 16px rgba(25,25,50,0.1)'],
  colors: {
    darkGreen: '#005272',
  },
})

lightTheme = responsiveFontSizes(lightTheme)

export default lightTheme
