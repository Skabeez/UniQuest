# Email Confirmation Setup Guide

## Problem
After email confirmation, users are redirected to `localhost:3000` which doesn't work on mobile devices.

## Solution
Configure Supabase to use deep linking for email confirmations.

## Steps to Fix

### 1. Update Supabase Dashboard Settings

Go to your Supabase Dashboard: https://fwgzodfujdhyvxpwnrrn.supabase.co

#### A. URL Configuration
1. Navigate to **Authentication → URL Configuration**
2. Update the following settings:
   - **Site URL**: `uniquest://uniquest.com/email-confirm`
   - **Redirect URLs**: Add these URLs:
     ```
     uniquest://uniquest.com/*
     uniquest://uniquest.com/email-confirm
     ```

#### B. Email Templates
1. Navigate to **Authentication → Email Templates**
2. Click on **"Confirm signup"** template
3. Make sure the confirmation button uses: `{{ .ConfirmationURL }}`
4. The template should look like this:
   ```html
   <h2>Confirm your signup</h2>
   <p>Follow this link to confirm your email:</p>
   <p><a href="{{ .ConfirmationURL }}">Confirm your email</a></p>
   ```

### 2. Test the Flow

1. Sign up with a new email address
2. Check your email inbox
3. Click the confirmation link
4. You should be redirected to the app with a success animation
5. The app will automatically redirect you to the Home page after 3 seconds

## What Was Changed in the Code

1. **Added deep link redirect URL** in `lib/auth/supabase_auth/email_auth.dart`:
   - Now uses `uniquest://uniquest.com/email-confirm` as the redirect URL

2. **Created Email Confirmation Page** at `lib/email_confirm/`:
   - Shows a success animation with confetti
   - Displays "Email Confirmed!" message
   - Auto-redirects to Home after 3 seconds
   - Manual "Continue to App" button

3. **Added route** in `lib/flutter_flow/nav/nav.dart`:
   - Route name: `EmailConfirm`
   - Path: `/email-confirm`

## User Experience

✅ **Before**: Users see "localhost refused to connect" error
✅ **After**: Users see a beautiful success page with confetti animation and smooth redirect

## Notes

- The deep link scheme `uniquest://` is already configured in AndroidManifest.xml
- The email confirmation page uses the existing Confetti animation
- The page matches the app's design system (yellow primary color, modern rounded corners)
